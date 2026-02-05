import 'package:drift/drift.dart';

// 本地歌单音乐列表
class LocalMusicListEntity extends Table {
  @override
  String get tableName => 'local_music_list';

  // 关联的歌单 ID
  IntColumn get orderId => integer()();

  // ID
  IntColumn get id => integer().autoIncrement()();

  // 歌曲 ID
  TextColumn get musicId => text()();
  // 歌曲名称
  TextColumn get name => text()();
  // 时长
  IntColumn get duration => integer()();
  // 歌曲封面
  TextColumn get cover => text().nullable()();
  // 歌手
  TextColumn get author => text().nullable()();
  // 歌曲来源
  TextColumn get origin => text()();

  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
