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

/// 搜索结果类型
enum SearchType {
  order(value: 'order', name: '歌单'),
  music(value: 'music', name: '歌曲');

  const SearchType({required this.value, required this.name});

  final String value;
  final String name;
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
