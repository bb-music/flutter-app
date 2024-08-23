import 'package:bbmusic/components/text_tags/tags.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/utils/clear_html_tags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicListTile extends StatelessWidget {
  final MusicItem music;
  final void Function() onMore;

  const MusicListTile(this.music, {super.key, required this.onMore});

  @override
  Widget build(BuildContext context) {
    final List<String> tags = [
      music.origin.name,
      seconds2duration(music.duration),
    ];
    return ListTile(
      title: Text(
        music.name,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: TextTags(tags: tags),
      trailing: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: onMore,
        child: const Icon(Icons.more_vert),
      ),
      onTap: () {
        Provider.of<PlayerModel>(context, listen: false).play(music: music);
      },
      onLongPress: onMore,
    );
  }
}
