import 'dart:convert';

import 'package:bbmusic/icons/icon.dart';
import 'package:bbmusic/modules/user_music_order/github/config_view.dart';
import 'package:bbmusic/modules/user_music_order/github/constants.dart';
import 'package:bbmusic/modules/user_music_order/github/types.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:uuid/uuid.dart';

import '../common.dart';

const uuid = Uuid();
final dio = Dio();

class UserMusicOrderForGithub implements UserMusicOrderOrigin {
  final dio = Dio();

  @override
  String name = GithubOriginConst.name;
  @override
  final String cname = GithubOriginConst.cname;
  @override
  final IconData icon = BBIcons.github;

  Function? listenChange;
  String repoUrl = '';
  String branch = '';
  String token = '';
  String filepath = '';

  Uri get _path {
    RepoInfo r = RepoInfo.format(repoUrl);
    return Uri.parse(
      'https://api.github.com/repos/${r.owner}/${r.repo}/contents/$filepath',
    );
  }

  Map<String, String> get _headers {
    final opt = {
      'Authorization': 'Bearer $token',
      'X-GitHub-Api-Version': '2022-11-28',
      'Accept': 'application/vnd.github+json',
    };
    return opt;
  }

  // 判断文件是否存在，不存在则创建
  _initFile() async {
    try {
      await dio.get(_path.toString(), queryParameters: {'ref': branch});
    } catch (e) {
      if (e is DioException) {
        if ((e).response?.statusCode == 404) {
          // 没有则文件创建
          try {
            await _update([], '创建歌单文件', '');
          } catch (e) {
            BotToast.showText(text: "创建文件失败");
            return Future.error(e);
          }
        }
      }

      return Future.error(e);
    }
  }

  Future<GithubFile> _loadData() async {
    Map<String, String> query = {'ref': branch};
    Response<dynamic>? response;
    try {
      response = await dio.get(_path.toString(), queryParameters: query);
      final res = GithubFile.fromJson(response.data);
      return res;
    } catch (e) {
      final msg = '$cname歌单获取失败';
      BotToast.showText(text: msg);
      return Future.error(msg);
    }
  }

  @override
  Widget? configBuild({
    Map<String, dynamic>? value,
    required Function(Map<String, dynamic>) onChange,
  }) {
    return GithubConfigView(value: value, onChange: onChange);
  }

  @override
  bool canUse() {
    return repoUrl.isNotEmpty &&
        token.isNotEmpty &&
        branch.isNotEmpty &&
        filepath.isNotEmpty;
  }

  @override
  Future<void> initConfig(config) async {
    repoUrl = config[GithubOriginConst.configFieldRepoUrl] ?? '';
    token = config[GithubOriginConst.configFieldToken] ?? '';
    branch = config[GithubOriginConst.configFieldBranch] ?? '';
    filepath = config[GithubOriginConst.configFieldFilepath] ?? '';
    dio.options.headers = _headers;
  }

  @override
  getList() async {
    if (!canUse()) {
      return [];
    }
    try {
      await _initFile();
      final res = await _loadData();
      return res.content;
    } catch (e) {
      BotToast.showText(text: "获取歌单列表失败");
      return [];
    }
  }

  Future _update(List<MusicOrderItem> list, String message, String sha) async {
    final jsonStr = json.encode(list);
    final content = base64Encode(
      utf8.encode(jsonStr),
    );

    Map<String, String> body = {
      'message': message,
      'sha': sha,
      'content': content,
    };
    if (branch.isNotEmpty) {
      body['branch'] = branch;
    }

    try {
      await dio.put(
        _path.toString(),
        data: body,
      );
    } catch (e) {
      return Future.error('编辑歌单失败');
    }
  }

  @override
  Future create(data) async {
    final res = await _loadData();
    final list = res.content;

    // 判断歌单是否已存在
    if (list.where((e) => e.name == data.name).isNotEmpty) {
      return Future.error('歌单已存在');
    }
    String id = uuid.v4();
    list.add(
      MusicOrderItem(
        id: id,
        name: data.name,
        cover: data.cover,
        desc: data.desc,
        author: data.author,
        musicList: data.musicList,
      ),
    );

    return _update(list, '创建歌单${data.name}($id)', res.sha);
  }

  @override
  Future update(data) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == data.id);
    final current = list[index];
    // 判断歌单是否已存在
    if (index < 0) {
      return Future.error('歌单不存在');
    }

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: data.name,
      cover: data.cover,
      desc: data.desc,
      author: data.author,
      musicList: current.musicList,
    );

    return _update(list, '删除歌单${data.name}($data.id)', res.sha);
  }

  @override
  Future delete(data) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == data.id);
    // 判断歌单是否已存在
    if (index < 0) {
      return Future.error('歌单不存在');
    }
    list.removeAt(index);
    return _update(list, '创建歌单${data.name}($data.id)', res.sha);
  }

  @override
  getDetail(id) async {
    final list = await getList();
    final index = list.indexWhere((r) => r.id == id);
    if (index < 0) {
      return Future.error('歌单不存在');
    }
    return list[index];
  }

  @override
  appendMusic(id, musics) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();
    current.musicList.removeWhere((m) => mids.contains(m.id));
    current.musicList.addAll(musics);

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: current.musicList,
    );

    return _update(list, '为歌单${current.name}($current.id)添加歌曲', res.sha);
  }

  @override
  updateMusic(id, musics) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();

    final newList = current.musicList.map((m) {
      if (mids.contains(m.id)) {
        final c = musics.firstWhere((e) => e.id == m.id);
        return MusicItem(
          name: c.name,
          cover: m.cover,
          id: m.id,
          duration: m.duration,
          author: m.author,
          origin: m.origin,
        );
      }
      return m;
    }).toList();

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: newList,
    );

    return _update(list, '为歌单${current.name}($current.id)更新歌曲', res.sha);
  }

  @override
  deleteMusic(id, musics) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    final current = list[index];
    List<String> mids = musics.map((e) => e.id).toList();
    current.musicList.removeWhere((m) => mids.contains(m.id));

    // 替换 list 指定位置的值
    list[index] = MusicOrderItem(
      id: current.id,
      name: current.name,
      cover: current.cover,
      desc: current.desc,
      author: current.author,
      musicList: current.musicList,
    );

    return _update(list, '为歌单${current.name}($current.id)删除歌曲', res.sha);
  }
}

class RepoInfo {
  final String owner;
  final String repo;

  const RepoInfo({required this.owner, required this.repo});

  factory RepoInfo.format(String url) {
    List<String> s = url.split('/');
    return RepoInfo(
      owner: s[3],
      repo: url.endsWith('.git') ? s[4].replaceAll('.git', '') : s[4],
    );
  }
}
