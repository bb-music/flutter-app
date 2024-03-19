import 'package:flutter/material.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';

class MusicOrderDetail extends StatelessWidget {
  final MusicOrderItem data;

  const MusicOrderDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
      ),
      body: ListView.builder(
          itemCount: data.musicList.length,
          itemBuilder: (context, index) {
            if (data.musicList.isEmpty) return null;
            final item = data.musicList[index];
            final List<String> tags = [
              item.origin.name,
              item.duration.toString()
            ];
            return ListTile(
              title: Text(item.name),
              subtitle: Row(
                children: tags.map((tag) {
                  return Text(
                    tag,
                    style: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),
            );
          }),
    );
  }
}
