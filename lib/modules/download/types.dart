class DownloadItem {
  final String name; // 文件名称
  final String url; // 文件下载地址
  DownloadStatus status; // 文件下载状态

  DownloadItem(this.name, this.url, this.status);
}

enum DownloadStatus {
  none(), // 未开始
  downloading(), // 下载中
  pause(), // 暂停
  success(), // 成功
  fail(), // 失败
}
