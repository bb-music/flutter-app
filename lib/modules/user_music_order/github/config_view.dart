import 'dart:async';

import 'package:bbmusic/modules/user_music_order/github/constants.dart';
import 'package:flutter/material.dart';

class GithubConfigView extends StatefulWidget {
  final Map<String, dynamic>? value;
  final Function(Map<String, dynamic>) onChange;

  const GithubConfigView({
    super.key,
    required this.value,
    required this.onChange,
  });

  @override
  State<GithubConfigView> createState() => _GithubConfigViewState();
}

class _GithubConfigViewState extends State<GithubConfigView> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _repoUrlController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _filepathController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    _repoUrlController.text =
        widget.value?[GithubOriginConst.configFieldRepoUrl] ?? '';
    _tokenController.text =
        widget.value?[GithubOriginConst.configFieldToken] ?? '';
    _branchController.text =
        widget.value?[GithubOriginConst.configFieldBranch] ?? '';
    _filepathController.text =
        widget.value?[GithubOriginConst.configFieldFilepath] ?? '';
  }

  _changeHandler() async {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      widget.onChange({
        GithubOriginConst.configFieldRepoUrl: _repoUrlController.text,
        GithubOriginConst.configFieldToken: _tokenController.text,
        GithubOriginConst.configFieldBranch: _branchController.text,
        GithubOriginConst.configFieldFilepath: _filepathController.text
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _repoUrlController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("仓库地址"),
          ),
          onChanged: (e) {
            _changeHandler();
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _tokenController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Token"),
          ),
          onChanged: (e) {
            _changeHandler();
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _branchController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("分支"),
          ),
          onChanged: (e) {
            _changeHandler();
          },
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _filepathController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("文件路径"),
          ),
          onChanged: (e) {
            _changeHandler();
          },
        ),
      ],
    );
  }
}
