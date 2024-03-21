import 'package:flutter/material.dart';
import 'package:flutter_app/modules/player/player.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:provider/provider.dart';

class PlayerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double coverWidth = MediaQuery.of(context).size.width - 200;
    return Consumer<PlayerModel>(
      builder: (context, player, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.width + 200,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                  bottom: 30,
                ),
                child: Text(
                  player.current!.name,
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  player.current!.cover,
                  width: coverWidth,
                  height: coverWidth,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    iconSize: 40,
                    onPressed: () {},
                    icon: const Icon(Icons.playlist_add),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ModeButton(size: 30),
                  PrevButton(size: 40),
                  PlayButton(size: 60),
                  NextButton(size: 40),
                  PlayerListButton(size: 30),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
