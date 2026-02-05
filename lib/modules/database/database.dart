import 'package:bbmusic/modules/database/entity/cloud_music_order.entity.dart';
import 'package:bbmusic/modules/database/entity/local_music_list.entity.dart';
import 'package:bbmusic/modules/database/entity/local_music_order.entity.dart';
import 'package:bbmusic/modules/database/entity/open_music_order_url.entity.dart';
import 'package:bbmusic/modules/database/entity/player_list.entity.dart';
import 'package:bbmusic/modules/database/entity/search_history.entity.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  CloudMusicOrderEntity,
  LocalMusicOrderEntity,
  LocalMusicListEntity,
  OpenMusicOrderUrlEntity,
  PlayerListEntity,
  SearchHistoryEntity,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'bbmusic_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
