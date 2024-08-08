import 'package:bbmusic/modules/download/config_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DownloadListView extends StatefulWidget {
  const DownloadListView({super.key});

  @override
  State<DownloadListView> createState() => _DownloadListViewState();
}

class _DownloadListViewState extends State<DownloadListView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('下载管理'), actions: [
        IconButton(
          onPressed: () {
            navigator.push(MaterialPageRoute(
              builder: (BuildContext context) {
                return const DownloadConfigView();
              },
            ));
          },
          icon: const Icon(Icons.settings),
        ),
      ]),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '下载中'),
              Tab(text: '已下载'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: Text('下载中'),
                ),
                Container(
                  child: Text('已下载'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
