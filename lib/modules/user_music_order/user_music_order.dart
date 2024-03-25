import 'package:flutter_app/modules/user_music_order/common.dart';
import 'package:flutter_app/modules/user_music_order/github/github.dart';
import 'package:flutter_app/modules/user_music_order/local/local.dart';

final List<UserMusicOrderOrigin> userMusicOrderOrigin = [
  UserMusicOrderForLocal(),
  UserMusicOrderForGithub()
];
