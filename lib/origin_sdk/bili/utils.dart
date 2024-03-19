class BiliId {
  String aid;
  String bvid;
  String? cid;

  BiliId({required this.aid, required this.bvid, this.cid = ""});

  factory BiliId.unicode(String id) {
    List<String> parts = id.split('_');
    if (parts.length < 2) {
      throw Exception('ID 格式不正确');
    }
    BiliId result = BiliId(aid: parts[0], bvid: parts[1]);
    if (parts.length > 2) {
      result.cid = parts[2];
    }
    return result;
  }

  String decode() {
    String id = '${aid}_${bvid}';
    if (cid != null && cid!.isNotEmpty) {
      id += '_$cid';
    }
    return id;
  }
}
