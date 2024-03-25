import 'dart:convert';

import 'package:flutter_app/icons/icon.dart';
import 'package:flutter_app/modules/user_music_order/github/config_view.dart';
import 'package:flutter_app/modules/user_music_order/github/constants.dart';
import 'package:flutter_app/modules/user_music_order/github/types.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../common.dart';

const uuid = Uuid();

class UserMusicOrderForGithub implements UserMusicOrderOrigin {
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

  Uri get _path {
    RepoInfo r = RepoInfo.format(repoUrl);
    return Uri.parse(
        'https://api.github.com/repos/${r.owner}/${r.repo}/contents/my.json');
  }

  Map<String, String> get _headers {
    return {
      'Authorization': 'Bearer ${token}',
      'X-GitHub-Api-Version': '2022-11-28',
      'Accept': 'application/vnd.github+json',
    };
  }

  UserMusicOrderForGithub() {
    _load();
  }

  Future<void> _load() async {
    await initConfig();
    if (listenChange != null) {
      listenChange!();
    }
  }

  Future<GithubFile> _loadData() async {
    Map<String, String> query = {};
    if (branch.isNotEmpty) {
      query['ref'] = branch;
    }
    final response = await http.get(
      _path.replace(queryParameters: query),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final res = GithubFile.fromJson(json.decode(response.body));
      return res;
    } else {
      throw Exception('$cname歌单获取失败');
    }
  }

  @override
  Widget configBuild() {
    return GithubConfigView(onChange: () {
      _load();
    });
  }

  @override
  bool canUse() {
    return repoUrl.isNotEmpty && token.isNotEmpty;
  }

  @override
  Future<void> initConfig() async {
    final localStorage = await SharedPreferences.getInstance();
    repoUrl = localStorage.getString(GithubOriginConst.cacheKeyRepoUrl) ?? '';
    token = localStorage.getString(GithubOriginConst.cacheKeyToken) ?? '';
    branch = localStorage.getString(GithubOriginConst.cacheKeyBranch) ?? '';
  }

  @override
  Future<List<MusicOrderItem>> getList() async {
    if (!canUse()) {
      return [];
    }
    final res = await _loadData();
    return res.content;
  }

  @override
  Future<void> create(data) async {
    final res = await _loadData();
    final list = res.content;

    // 判断歌单是否已存在
    if (list.where((e) => e.name == data.name).isNotEmpty) {
      throw Exception('歌单已存在');
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

    final jsonStr = json.encode(list);
    final content = base64Encode(
      utf8.encode(jsonStr),
    );

    final response = await http.put(
      _path,
      headers: _headers,
      body: json.encode(
        {
          'message': '创建歌单${data.name}($id)',
          'sha': res.sha,
          'content': content,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('创建歌单失败');
    }
  }

  Future<void> _update(
      List<MusicOrderItem> list, String message, String sha) async {
    final jsonStr = json.encode(list);
    final content = base64Encode(
      utf8.encode(jsonStr),
    );

    final response = await http.put(
      _path,
      headers: _headers,
      body: json.encode(
        {
          'message': message,
          'sha': sha,
          'content': content,
          'branch': branch,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('编辑歌单失败');
    }
  }

  @override
  Future<void> update(data) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == data.id);
    final current = list[index];
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
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

    return _update(list, '创建歌单${data.name}($data.id)', res.sha);
  }

  @override
  Future<void> delete(data) async {
    final res = await _loadData();
    final list = res.content;
    final index = list.indexWhere((e) => e.id == data.id);
    // 判断歌单是否已存在
    if (index < 0) {
      throw Exception('歌单不存在');
    }
    list.removeAt(index);
    return _update(list, '创建歌单${data.name}($data.id)', res.sha);
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
