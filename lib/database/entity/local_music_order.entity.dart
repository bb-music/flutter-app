import 'package:drift/drift.dart';

// 本地歌单列表
class LocalMusicOrderEntity extends Table {
  @override
  String get tableName => 'local_music_order';

  // ID
  TextColumn get id => text()();
  // 歌单名称
  TextColumn get name => text()();
  // 歌单描述
  TextColumn get desc => text().nullable()();
  // 封面
  TextColumn get cover => text().nullable()();
  // 作者
  TextColumn get author => text().nullable()();

  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // 更新时间
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
