import 'package:bbmusic/modules/user_music_order/common.dart';
import 'package:bbmusic/modules/user_music_order/github/github.dart';
import 'package:bbmusic/modules/user_music_order/local/local.dart';

final List<UserMusicOrderOrigin> userMusicOrderOrigin = [
  UserMusicOrderForLocal(),
  UserMusicOrderForGithub()
];
