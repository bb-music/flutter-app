import 'package:flutter_app/origin_sdk/bili/utils.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:flutter_app/utils/clear_html_tags.dart';

/// 签名秘钥
class SignData {
  final String imgKey;
  final String subKey;

  const SignData({required this.imgKey, required this.subKey});

  factory SignData.fromJson(Map<String, dynamic> json) {
    String imgUrl = json['data']['wbi_img']['img_url'];
    String subUrl = json['data']['wbi_img']['sub_url'];
    String imgKey =
        imgUrl.substring(imgUrl.lastIndexOf('/') + 1, imgUrl.lastIndexOf('.'));
    String subKey =
        subUrl.substring(subUrl.lastIndexOf('/') + 1, subUrl.lastIndexOf('.'));
    return SignData(
      imgKey: imgKey,
      subKey: subKey,
    );
  }
}

/// 签名秘钥
class SpiData {
  final String b3;
  final String b4;

  const SpiData({required this.b3, required this.b4});

  factory SpiData.fromJson(Map<String, dynamic> json) {
    return SpiData(
      b3: json['data']['b_3'],
      b4: json['data']['b_4'],
    );
  }
}

/// 搜索结果
class BiliSearchResponse extends SearchResponse {
  BiliSearchResponse({
    required super.current,
    required super.total,
    required super.pageSize,
    required super.data,
  });
  factory BiliSearchResponse.fromJson(Map<String, dynamic> json) {
    var result = json['data']['result'].toList();
    List<BiliSearchItem> data = [];
    for (var j in result) {
      if (j['type'] != 'ketang') {
        data.add(BiliSearchItem.fromJson(j));
      }
    }
    return BiliSearchResponse(
      current: json['data']['page'],
      total: json['data']['numResults'],
      pageSize: json['data']['pagesize'],
      data: data,
    );
  }
}

/// 搜索条目
class BiliSearchItem extends SearchItem {
  const BiliSearchItem({
    required super.id,
    required super.cover,
    required super.name,
    required super.duration,
    required super.author,
    required super.origin,
    super.musicList,
    super.type,
  });
  factory BiliSearchItem.fromJson(Map<String, dynamic> json) {
    final String aid = json['aid'].toString();
    final String bvid = json['bvid'];
    String id = BiliId(aid: aid, bvid: bvid).decode();

    SearchType? type;
    List<MusicItem> musicList = [];

    // 判断是否为歌单
    if (json['videos'] != null) {
      type = SearchType.order;
      final pages = json['pages'].toList();

      for (var j in pages) {
        final mid = BiliId(
          aid: aid,
          bvid: bvid,
          cid: j['cid']?.toString(),
        ).decode();

        final item = MusicItem(
          id: mid,
          cover: j['first_frame'] ?? "",
          name: j['part'],
          duration: j['duration'],
          author: '',
          origin: OriginType.bili,
        );
        musicList.add(item);
      }
    }
    if (musicList.isNotEmpty) {
      if (json['videos'] > 1) {
        type = SearchType.order;
      } else {
        type = SearchType.music;
        id = musicList[0].id;
      }
    }

    return BiliSearchItem(
      id: id,
      cover: json['pic'],
      name: clearHtmlTags(json['title']),
      duration: json['duration'] is String
          ? duration2seconds(json['duration'])
          : json['duration'],
      author: json['author'] ?? "",
      origin: OriginType.bili,
      type: type,
      musicList: musicList,
    );
  }
}

class BiliMusicDetail extends MusicDetail {
  BiliMusicDetail({
    required super.id,
    required super.cover,
    required super.name,
    required super.duration,
    required super.author,
    required super.origin,
    required super.url,
  });

  factory BiliMusicDetail.fromJson(
    String id,
    Map<String, dynamic> json,
  ) {
    return BiliMusicDetail(
      id: id,
      cover: json['first_frame'],
      name: json['part'],
      duration: json['duration'],
      author: '',
      origin: OriginType.bili,
      url: '',
    );
  }
}
