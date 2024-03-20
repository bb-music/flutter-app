// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/text_tags/tags.dart';
import 'package:flutter_app/modules/music_order/music_order_detail.dart';
import 'package:flutter_app/modules/player/player.dart';
import 'package:flutter_app/modules/player/player.model.dart';
import 'package:flutter_app/origin_sdk/origin_types.dart';
import 'package:flutter_app/origin_sdk/service.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ScrollController _scrollController = ScrollController();
  final _keywordController = TextEditingController(text: "不问别离");
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
    var player = Provider.of<PlayerModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
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
                child: Image.network(
                  cover,
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
                  player.play(
                    MusicItem(
                      id: detail.id,
                      cover: detail.cover,
                      name: detail.name,
                      duration: detail.duration,
                      author: detail.author,
                      origin: detail.origin,
                    ),
                  );
                }
              },
            );
          }),
      floatingActionButton: PlayerView(),
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
    return Stack(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: TextField(
              controller: keywordController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "请输入歌曲/歌单名搜索",
                contentPadding: EdgeInsets.symmetric(horizontal: 25),
              ),
            ),
          ),
        ),
        Positioned(
          right: 7,
          bottom: 5,
          child: SizedBox(
            height: 40,
            child: FilledButton(
              onPressed: onSearch,
              child: const Text("搜 索"),
            ),
          ),
        )
      ],
    );
  }
}
