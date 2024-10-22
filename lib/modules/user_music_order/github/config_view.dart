import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:bbmusic/modules/music_order/model.dart';
import 'package:bbmusic/modules/user_music_order/github/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GithubConfigView extends StatefulWidget {
  final Function? onChange;

  const GithubConfigView({super.key, this.onChange});

  @override
  State<GithubConfigView> createState() => _GithubConfigViewState();
}

class _GithubConfigViewState extends State<GithubConfigView> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _repoUrlController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final localStorage = await SharedPreferences.getInstance();

    _repoUrlController.text =
        localStorage.getString(GithubOriginConst.cacheKeyRepoUrl) ?? '';
    _tokenController.text =
        localStorage.getString(GithubOriginConst.cacheKeyToken) ?? '';
    _branchController.text =
        localStorage.getString(GithubOriginConst.cacheKeyBranch) ?? '';
  }

  _saveHandler() async {
    await saveConfigData(
      repoUrl: _repoUrlController.text,
      token: _tokenController.text,
      branch: _branchController.text,
    );
    if (widget.onChange != null) widget.onChange!();
    BotToast.showText(text: '保存成功');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GithubOriginConst.cname),
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
              controller: _repoUrlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("仓库地址"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Token"),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _branchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("分支"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () async {
            await _saveHandler();
            if (context.mounted) {
              Provider.of<UserMusicOrderModel>(context, listen: false)
                  .load(GithubOriginConst.name);
              Navigator.of(context).pop();
            }
          },
          child: const Text("保 存"),
        ),
      ),
    );
  }
}

/// 配置信息缓存到本地
saveConfigData({
  required String repoUrl,
  required String token,
  required String branch,
}) async {
  final localStorage = await SharedPreferences.getInstance();
  localStorage.setString(GithubOriginConst.cacheKeyRepoUrl, repoUrl);
  localStorage.setString(GithubOriginConst.cacheKeyToken, token);
  localStorage.setString(GithubOriginConst.cacheKeyBranch, branch);
}
