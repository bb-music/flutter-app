import 'package:drift/drift.dart';

// 歌单广场源
class OpenMusicOrderUrlEntity extends Table {
  @override
  String get tableName => 'open_music_order_url';

  IntColumn get id => integer().autoIncrement()();
  // 歌单广场源 URL
  TextColumn get url => text()();
  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
