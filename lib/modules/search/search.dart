// import 'dart:async';
import 'package:bbmusic/components/sheet/bottom_sheet.dart';
import 'package:bbmusic/modules/music_order/list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/components/text_tags/tags.dart';
import 'package:bbmusic/modules/music_order/detail.dart';
import 'package:bbmusic/modules/player/player.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ScrollController _scrollController = ScrollController();
  final _keywordController = TextEditingController(text: "");
  int _current = 1;
  bool _loading = false;
  final List<SearchItem> _searchItemList = [];

  // 搜索事件
  void _searchHandler(bool clean) async {
    var keyword = _keywordController.text;
    if (keyword.isEmpty) {
      setState(() {
        _searchItemList.clear();
        _loading = true;
      });
      return;
    }

    final p = SearchParams(keyword: keyword, page: _current);
    setState(() {
      _loading = true;
    });
    service.search(p).then((value) {
      setState(() {
        if (clean) {
          _searchItemList.clear();
        }
        _searchItemList.addAll(value.data);
        _loading = true;
      });
    });
  }

  // 单个歌曲点击
  void _onMusicClickHandler(SearchItem detail) {
    final music = MusicItem(
      id: detail.id,
      cover: detail.cover,
      name: detail.name,
      duration: detail.duration,
      author: detail.author,
      origin: detail.origin,
    );
    openBottomSheet(context, [
      SheetItem(
        title: Text(
          music.name,
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      SheetItem(
        title: const Text('播放'),
        onPressed: () {
          Provider.of<PlayerModel>(context, listen: false).play(music: music);
        },
      ),
      SheetItem(
        title: const Text('下载'),
        onPressed: () {},
      ),
      SheetItem(
        title: const Text('添加到歌单'),
        onPressed: () {
          collectToMusicOrder(context, [music]);
        },
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Reach the bottom, load more data
        _current += 1;
        _searchHandler(false);
      }
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _SearchForm(
          keywordController: _keywordController,
          onSearch: () {
            _searchHandler(true);
          },
        ),
        toolbarHeight: 70,
      ),
      body: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: _searchItemList.length + 1,
          itemBuilder: (ctx, index) {
            if (_searchItemList.isEmpty) {
              return null;
            }
            if (index == _searchItemList.length) {
              return SizedBox(
                height: 40,
                child: Center(
                  child: _loading ? const Text("加载中") : const Text("到底了"),
                ),
              );
            }
            final item = _searchItemList[index];
            String cover = item.cover;
            String name = item.name;
            final List<String> tags = [item.origin.name, item.author];
            if (cover.startsWith("//")) {
              cover = "http:$cover";
            }

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: CachedNetworkImage(
                  imageUrl: cover,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: TextTags(tags: tags),
              onTap: () async {
                final detail = await service.searchDetail(item.id);
                if (detail.type == SearchType.order) {
                  // 歌单
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => MusicOrderDetail(
                        data: MusicOrderItem(
                          id: detail.id,
                          cover: detail.cover,
                          name: detail.name,
                          author: detail.author,
                          desc: "",
                          musicList: detail.musicList ?? [],
                        ),
                      ),
                    ),
                  );
                } else {
                  _onMusicClickHandler(detail);
                }
              },
            );
          }),
      floatingActionButton: const PlayerView(),
    );
  }
}

class _SearchForm extends StatelessWidget {
  final TextEditingController keywordController;
  final Function() onSearch;

  const _SearchForm({
    super.key,
    required this.keywordController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: keywordController,
              onSubmitted: (value) => onSearch(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "请输入歌曲/歌单名",
                contentPadding: EdgeInsets.only(left: 25, right: 10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton(
              child: const Text('取消'),
              onPressed: () {
                navigator.pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
