import 'package:drift/drift.dart';

// 搜索历史
class SearchHistoryEntity extends Table {
  @override
  String get tableName => 'search_history';

  // name
  TextColumn get name => text().unique()();
  // 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
