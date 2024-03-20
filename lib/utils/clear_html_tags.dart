String clearHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText
      .replaceAll(exp, '')
      .replaceAll(RegExp(r'&nbsp;|&amp;'), ' ')
      .replaceAll(RegExp(r'】'), '-')
      .replaceAll('【', '');
}

/// 将 mm:ss 格式的时间转换为 秒
int duration2seconds(String durationStr) {
  if (durationStr.isEmpty) {
    return 0;
  }
  List<String> parts = durationStr.split(':');
  if (parts.length < 2) {
    return 0;
  }
  int minutes = int.tryParse(parts[0]) ?? 0;
  int seconds = int.tryParse(parts[1]) ?? 0;
  return minutes * 60 + seconds;
}

/// 将 mm:ss 格式的时间转换为 秒
String seconds2duration(int seconds) {
  int minutes = (seconds / 60).floor();
  int remainingSeconds = seconds % 60;
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');
  return '$minutesStr:$secondsStr';
}
