import 'package:bbmusic/database/database.dart';

const defaultUrls = [
  'https://lvyueyang.github.io/bb-music-order-open/list.json'
];

Future<List<String>> getMusicOrderUrl() async {
  final db = AppDatabase();
  final res = await db.managers.openMusicOrderUrlEntity.get();
  if (res.isEmpty) {
    return defaultUrls;
  }
  return res.map((e) => e.url).toList();
}
