import 'dart:async';

// 节流方法
class Throttle {
  final Duration duration;
  Timer? _timer;

  Throttle(this.duration);

  void call(Function callback) {
    if (_timer?.isActive ?? false) {
      return;
    }
    _timer = Timer(duration, () {
      callback();
      _timer = null;
    });
  }
}
