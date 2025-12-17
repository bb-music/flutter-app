import 'dart:convert';

import 'package:bbmusic/origin_sdk/origin_types.dart';

class GithubFile {
  String name;
  String path;
  String sha;
  int size;
  String url;
  String htmlUrl;
  String gitUrl;
  String downloadUrl;
  String type;
  List<MusicOrderItem> content;
  String encoding;
  Links links;

  GithubFile({
    required this.name,
    required this.path,
    required this.sha,
    required this.size,
    required this.url,
    required this.htmlUrl,
    required this.gitUrl,
    required this.downloadUrl,
    required this.type,
    required this.content,
    required this.encoding,
    required this.links,
  });

  factory GithubFile.fromJson(Map<String, dynamic> json) {
    return GithubFile(
      name: json['name'],
      path: json['path'],
      sha: json['sha'],
      size: json['size'],
      url: json['url'],
      htmlUrl: json['html_url'],
      gitUrl: json['git_url'],
      downloadUrl: json['download_url'],
      type: json['type'],
      content: decodeGithubFileContent(json['content']),
      encoding: json['encoding'],
      links: Links.fromJson(json['_links']),
    );
  }
}

class Links {
  String self;
  String git;
  String html;

  Links({
    required this.self,
    required this.git,
    required this.html,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'],
      git: json['git'],
      html: json['html'],
    );
  }
}

List<MusicOrderItem> decodeGithubFileContent(String content) {
  final contentRaw = content.replaceAll('\n', '');
  // base 64 解码
  String raw = const Utf8Decoder().convert(base64Decode(contentRaw));
  final data = json.decode(raw.trim().isEmpty ? '[]' : raw);
  List<MusicOrderItem> list = [];
  for (var item in data) {
    list.add(
      MusicOrderItem.fromJson(item),
    );
  }
  return list;
}
