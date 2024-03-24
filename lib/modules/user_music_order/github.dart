import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_app/icons/icon.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './common.dart';

String _name = 'github';
String _cname = 'GitHub';
const String _cacheKeyRepoUrl = 'umo_origin_github_repo_url';
const String _cacheKeyBranch = 'umo_origin_github_branch';
const String _cacheKeyToken = 'umo_origin_github_token';

class UserMusicOrderForGithub implements UserMusicOrderOrigin {
  @override
  String name = _name;
  @override
  final String cname = _cname;
  @override
  final IconData icon = BBIcons.github;

  Function? listenChange;
  String repoUrl = '';
  String branch = '';
  String token = '';

  UserMusicOrderForGithub() {
    _load();
  }

  @override
  Widget configBuild() {
    return GithubConfigView(onChange: () {
      _load();
    });
  }

  @override
  Future<void> initConfig() async {
    final localStorage = await SharedPreferences.getInstance();
    repoUrl = localStorage.getString(_cacheKeyRepoUrl) ?? '';
    token = localStorage.getString(_cacheKeyToken) ?? '';
    branch = localStorage.getString(_cacheKeyBranch) ?? '';
  }

  @override
  Future<List<MusicOrderItem>> getList() async {
    final response = await http.get(
      _path,
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final content = (json.decode(response.body)['content'] as String)
          .replaceAll('\n', '');
      // base 64 解码
      String raw = Utf8Decoder().convert(base64Decode(content));

      final data = json.decode(raw);

      List<MusicOrderItem> list = [];
      for (var item in data) {
        print('itemitemitemitem');
        print(item);
        List<MusicItem> musicList = [];
        for (var music in (item['musicList'] ?? [])) {
          musicList.add(
            MusicItem(
              id: music['id'],
              cover: music['cover'],
              name: music['name'],
              duration: music['duration'],
              author: music['author'],
              origin: OriginType.getByValue(music['origin']),
            ),
          );
        }

        list.add(
          MusicOrderItem(
            id: item['id'],
            cover: item['cover'],
            name: item['name'],
            desc: item['desc'] ?? '',
            author: item['author'] ?? '',
            musicList: musicList ?? [],
          ),
        );
      }
      return list;
    } else {
      throw Exception('$cname歌单获取失败');
    }
  }

  Future<void> _load() async {
    await initConfig();
    if (listenChange != null) {
      listenChange!();
    }
  }

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

class GithubConfigView extends StatefulWidget {
  final Function? onChange;

  const GithubConfigView({super.key, this.onChange});

  @override
  State<GithubConfigView> createState() => _GithubConfigViewState();
}

class _GithubConfigViewState extends State<GithubConfigView> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _repoUrlController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final localStorage = await SharedPreferences.getInstance();

    _repoUrlController.text = localStorage.getString(_cacheKeyRepoUrl) ?? '';
    _tokenController.text = localStorage.getString(_cacheKeyToken) ?? '';
    _branchController.text = localStorage.getString(_cacheKeyBranch) ?? '';
  }

  _saveHandler() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setString(_cacheKeyRepoUrl, _repoUrlController.text);
    localStorage.setString(_cacheKeyToken, _tokenController.text);
    localStorage.setString(_cacheKeyBranch, _branchController.text);
    if (widget.onChange != null) widget.onChange!();
    BotToast.showText(text: '保存成功');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cname),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Column(
          children: [
            TextField(
              controller: _repoUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("仓库地址"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Token"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _branchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("分支"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: _saveHandler,
          child: const Text("保 存"),
        ),
      ),
    );
  }
}
