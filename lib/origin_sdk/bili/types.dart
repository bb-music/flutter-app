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

/// 搜索参数
class SearchParams {
  final String keyword;
  final int page;
  final String searchType = 'video';

  const SearchParams({
    required this.keyword,
    required this.page,
  });
}

/// 搜索结果
class SearchResponse {
  final int current; // 当前页
  final int total; // 总数
  final int pageSize; // 每页数
  final List<SearchItem> data; // 结果

  SearchResponse({
    required this.current,
    required this.total,
    required this.pageSize,
    required this.data,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      current: json['data']['curpage'],
      total: json['data']['total'],
      pageSize: json['data']['pagesize'],
      data: json['data']['data'],
    );
  }
}

/// 搜索条目
class SearchItem {
  String id; // ID
  String cover; // 封面
  String name; // 名称
  int duration; // 时长
  String author; // 作者
  SearchType? type; // 类型
  OriginType origin; // 来源
  List<MusicItem> musicList; // 音乐列表 Type 为 order 时会有

  SearchItem({
    required this.id,
    required this.cover,
    required this.name,
    required this.duration,
    required this.author,
    required this.type,
    required this.origin,
    required this.musicList,
  });
}

enum SearchType {
  // 定义 SearchType 枚举类型
  // 可根据实际情况添加更多类型
  order,
  normal,
}

enum OriginType {
  // 定义 OriginType 枚举类型
  // 可根据实际情况添加更多类型
  source1,
  source2,
}

class MusicItem {
  // 定义 MusicItem 类
  // 可根据实际情况添加更多字段
}
