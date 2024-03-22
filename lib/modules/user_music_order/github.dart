import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

import './common.dart';

class UserMusicOrderForGithub extends UserMusicOrderOrigin {
  final String name = 'github';
  final String cname = 'GitHub';
  final Widget configWidget = Container();

  String repoUrl = '';
  String branch = '';
  String token = '';

  @override
  Future<List<MusicOrderItem>> getList() async {
    final response = await http.get(
      _path,
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      List<MusicOrderItem> list = [];
      for (var item in data) {
        List<MusicItem> musicList = [];
        for (var music in item['musics']) {
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
            name: item['name'],
            desc: item['desc'],
            author: item['author'],
            musicList: musicList,
          ),
        );
      }
      return list;
    } else {
      throw Exception('$cname歌单获取失败');
    }
  }

  Uri get _path {
    RepoInfo r = RepoInfo.format(repoUrl);
    return Uri.parse('/repos/${r.owner}/${r.repo}/contents/my.json');
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
