import 'package:drift/drift.dart';

// 播放列表
class PlayerListEntity extends Table {
  @override
  String get tableName => 'player_list';

  // 歌曲 ID
  TextColumn get id => text()();
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
