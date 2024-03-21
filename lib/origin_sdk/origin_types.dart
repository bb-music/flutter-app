/// 搜索结果类型
enum SearchType {
  order(value: 'order', name: '歌单'),
  music(value: 'music', name: '歌曲');

  const SearchType({required this.value, required this.name});

  final String value;
  final String name;

  static SearchType getByValue(String value) {
    return values.firstWhere((element) => element.value == value);
  }
}

/// 音乐源
enum OriginType {
  bili(value: 'bili', name: '哔哩哔哩'),
  youTube(value: 'youTube', name: 'YouTube');

  const OriginType({required this.value, required this.name});

  final String value;
  final String name;

  static OriginType getByValue(String value) {
    return values.firstWhere((element) => element.value == value);
  }
}

/// 搜索参数
class SearchParams {
  final String keyword;
  final int page;

  const SearchParams({
    required this.keyword,
    required this.page,
  });
}

/// 搜索结果
abstract class SearchResponse {
  final int current; // 当前页
  final int total; // 总数
  final int pageSize; // 每页数
  final List<SearchItem> data; // 结果

  const SearchResponse({
    required this.current,
    required this.total,
    required this.pageSize,
    required this.data,
  });
}

/// 搜索条目
class SearchItem {
  final String id; // ID
  final String cover; // 封面
  final String name; // 名称
  final int duration; // 时长
  final String author; // 作者
  final SearchType? type; // 类型
  final OriginType origin; // 来源
  final List<MusicItem>? musicList; // 音乐列表 Type 为 order 时会有

  const SearchItem({
    required this.id,
    required this.cover,
    required this.name,
    required this.duration,
    required this.author,
    required this.origin,
    this.musicList,
    this.type,
  });
}

/// 歌曲简要信息
class MusicItem {
  final String id; // ID
  final String cover; // 封面
  final String name; // 名称
  final int duration; // 时长
  final String author; // 作者
  final OriginType origin; // 来源

  const MusicItem({
    required this.id,
    required this.cover,
    required this.name,
    required this.duration,
    required this.author,
    required this.origin,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "cover": cover,
      "name": name,
      "duration": duration,
      "author": author,
      "origin": origin.value,
    };
  }
}

/// 歌单
class MusicOrderItem {
  final String id; // 歌单 ID
  final String name; // 名称
  final String desc; // 描述
  final String author; // 作者
  final List<MusicItem> musicList; // 歌曲列表
  final String? cover; // 封面
  final String? createdAt; // 创建时间
  final String? updatedAt; // 更新时间

  const MusicOrderItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.author,
    required this.musicList,
    this.cover,
    this.createdAt,
    this.updatedAt,
  });
}

/// 歌曲详情
class MusicDetail {
  final String id; // ID
  final String cover; // 封面
  final String name; // 名称
  final int duration; // 时长
  final String author; // 作者
  final OriginType origin; // 来源
  final String url; // 播放地址

  const MusicDetail({
    required this.id,
    required this.cover,
    required this.name,
    required this.duration,
    required this.author,
    required this.origin,
    required this.url,
  });
}

class MusicUrl {
  final String url; // 播放地址
  final Map<String, String>? headers; // 请求头
  const MusicUrl({required this.url, this.headers});
}

/// 歌单源服务
abstract class OriginService {
  /// 搜索
  Future<SearchResponse> search(SearchParams params);

  /// 搜索详情
  Future<SearchItem> searchDetail(String id);

  /// 歌曲详情
  Future<MusicUrl> getMusicUrl(String id);

  // /// 下载歌曲
  // Future<void> downloadMusic(String id, String name, String targetDir);
}
