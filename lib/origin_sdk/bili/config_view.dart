import 'package:flutter/material.dart';
import 'package:bbmusic/modules/user_music_order/github/constants.dart';

class BiliConfigView extends StatefulWidget {
  final Function? onChange;

  const BiliConfigView({super.key, this.onChange});

  @override
  State<BiliConfigView> createState() => _BiliConfigViewState();
}

class _BiliConfigViewState extends State<BiliConfigView> {
  // final TextEditingController _signImgKeyController = TextEditingController();
  // final TextEditingController _signSubKeyController = TextEditingController();
  // final TextEditingController _spiB3Controller = TextEditingController();
  // final TextEditingController _spiB4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        child: const Column(
          children: [],
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
