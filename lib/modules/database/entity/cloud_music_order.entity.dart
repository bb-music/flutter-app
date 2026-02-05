import 'package:drift/drift.dart';

// 云歌单列表
class CloudMusicOrderEntity extends Table {
  @override
  String get tableName => 'cloud_music_order';

  // ID
  IntColumn get id => integer().autoIncrement()();
  // 歌单源
  TextColumn get origin => text()();
  // 名称
  TextColumn get subName => text()();
  // 配置信息
  TextColumn get config => text()();

  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
