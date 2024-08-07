import 'package:bot_toast/bot_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cacheKey = 'open_music_order_list';
const defaultUrls = [
  'https://lvyueyang.github.io/bb-music-order-open/list.json'
];

Future<List<String>> getMusicOrderUrl() async {
  final localStorage = await SharedPreferences.getInstance();
  final List<String> urls = localStorage.getStringList(cacheKey) ??
      ["https://lvyueyang.github.io/bb-music-order-open/list.json"];
  return urls;
}

setMusicOrderUrl(List<String> list) async {
  final localStorage = await SharedPreferences.getInstance();
  localStorage.setStringList(cacheKey, list);
  BotToast.showText(text: '保存成功');
}
