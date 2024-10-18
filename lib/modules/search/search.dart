import 'dart:async';

import 'package:bbmusic/components/sheet/bottom_sheet.dart';
import 'package:bbmusic/constants/cache_key.dart';
import 'package:bbmusic/modules/music_order/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/components/text_tags/tags.dart';
import 'package:bbmusic/modules/music_order/detail.dart';
import 'package:bbmusic/modules/player/player.dart';
import 'package:bbmusic/modules/player/model.dart';
import 'package:bbmusic/origin_sdk/origin_types.dart';
import 'package:bbmusic/origin_sdk/service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final ScrollController _scrollController = ScrollController();
  final _keywordController = TextEditingController(text: "");
  final _focusNode = FocusNode();
  int _current = 1;
  bool _loading = false;
  final List<SearchItem> _searchItemList = [];
  List<String> _searchHistory = [];
  List<SearchSuggestItem> _searchSuggest = [];

  // 搜索事件
  void _searchHandler(bool clean) async {
    var keyword = _keywordController.text;
    if (keyword.isEmpty) {
      setState(() {
        _searchItemList.clear();
        _loading = false;
      });
      return;
    }

    final p = SearchParams(keyword: keyword, page: _current);
    setState(() {
      _loading = true;
    });
    service.search(p).then((value) {
      updateSearchHistory(keyword);
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
    final player = Provider.of<PlayerModel>(context, listen: false);
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
          player.play(music: music);
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
      SheetItem(
        title: const Text('添加到播放列表'),
        onPressed: () {
          player.addPlayerList([music]);
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
        _current += 1;
        _searchHandler(false);
      }
    });
    getSearchHistory();
  }

  getSearchHistory() async {
    final localStorage = await SharedPreferences.getInstance();
    final list = localStorage.getStringList(CacheKey.searchHistory);

    setState(() {
      _searchHistory = list ?? [];
    });
  }

  updateSearchHistory(String keyword, {bool isDelete = false}) async {
    final localStorage = await SharedPreferences.getInstance();
    final list = localStorage.getStringList(CacheKey.searchHistory) ?? [];
    if (list.contains(keyword)) {
      list.remove(keyword);
    }
    // 添加
    if (!isDelete) {
      list.insert(0, keyword);
      // 最多 40 条
      if (list.length > 40) {
        list.removeLast();
      }
    }
    await localStorage.setStringList(CacheKey.searchHistory, list);
    setState(() {
      _searchHistory = list;
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Timer? _debounceTimer;
  _onInputChange(String value) {
    // 防抖
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      service.searchSuggest(_keywordController.text).then((list) {
        setState(() {
          _searchSuggest = list;
        });
      });
    });
  }

  Widget buildSearchHistory() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: double.infinity,
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _searchHistory.map((keyword) {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              onTap: () {
                _keywordController.text = keyword;
                _searchHandler(true);
              },
              onLongPress: () {
                openBottomSheet(
                  context,
                  [
                    SheetItem(
                      title: const Text("删除"),
                      onPressed: () {
                        updateSearchHistory(keyword, isDelete: true);
                      },
                    ),
                  ],
                );
              },
              child: Container(
                padding: const EdgeInsets.only(
                  top: 6,
                  bottom: 6,
                  left: 12,
                  right: 12,
                ),
                child: Text(keyword),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildSearchSuggest() {
    return ListView(
      children: _searchSuggest.map((item) {
        // 渲染 html
        return ListTile(
          title: Text(item.value),
          onTap: () {
            _keywordController.text = item.value;
            _searchHandler(true);
          },
        );
      }).toList(),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_focusNode.hasFocus && _searchSuggest.isNotEmpty) {
      return buildSearchSuggest();
    }
    if (_searchItemList.isEmpty) {
      return buildSearchHistory();
    }
    var navigator = Navigator.of(context);
    return ListView.builder(
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _SearchForm(
          keywordController: _keywordController,
          onSearch: () {
            _searchHandler(true);
          },
          onInput: _onInputChange,
          focusNode: _focusNode,
        ),
        toolbarHeight: 70,
      ),
      body: buildBody(context),
      floatingActionButton: const PlayerView(),
    );
  }
}

class _SearchForm extends StatefulWidget {
  final TextEditingController keywordController;
  final Function() onSearch;
  final Function(String value) onInput;
  final FocusNode focusNode;

  const _SearchForm({
    super.key,
    required this.keywordController,
    required this.onSearch,
    required this.onInput,
    required this.focusNode,
  });

  @override
  State<_SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
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
              controller: widget.keywordController,
              onSubmitted: (value) => widget.onSearch(),
              autofocus: true,
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "请输入歌曲/歌单名",
                contentPadding: EdgeInsets.only(left: 25, right: 10),
              ),
              onChanged: (value) {
                widget.onInput(value);
              },
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
