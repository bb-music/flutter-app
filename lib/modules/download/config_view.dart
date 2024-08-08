import 'package:flutter/material.dart';

class DownloadConfigView extends StatefulWidget {
  const DownloadConfigView({super.key});

  @override
  State<DownloadConfigView> createState() => _DownloadConfigViewState();
}

class _DownloadConfigViewState extends State<DownloadConfigView> {
  final TextEditingController _parallelCountController =
      TextEditingController();
  final TextEditingController _downloadPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("下载设置"),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: Column(
          children: [
            TextField(
              controller: _parallelCountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("同时下载文件数"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _downloadPathController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("默认下载位置"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {},
          child: const Text("保 存"),
        ),
      ),
    );
  }
}
