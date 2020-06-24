import 'dart:js' as js;

import 'package:flutter/foundation.dart';

class CountTimer {
  Duration duration;

  /// time string representation
  int representation = 0;

  /// the real duration.
  Duration _duration;
  DateTime _begin;
  Duration _remainingTime;
  bool pasued = false;
  List<bool> called = [false, false, false, false, false, false];

  CountTimer({this.duration, this.representation}) {
    _remainingTime = duration;
  }

  void start() {
    _begin = DateTime.now();
    _duration = this.duration;
    called = [false, false, false, false, false, false];
  }

  void updateDuration(Duration d) {
    _remainingTime = d;
    called = [false, false, false, false, false, false];
  }

  void pause() {
    pasued = true;
  }

  void resume() {
    _begin = DateTime.now();
    _duration = _remainingTime;
    pasued = false;
  }

  Duration update() {
    Duration passed = DateTime.now().difference(_begin);
    if (!pasued) _remainingTime = this._duration - passed;
    if (_remainingTime.inSeconds <= 5) {
      if (!called[_remainingTime.inSeconds]) {
        called[_remainingTime.inSeconds] = true;
        if (_remainingTime.inSeconds == 0)
          playAudio('assets/start_end.mp3');
        else
          playAudio('assets/bee.mp3');
      }
    }
    return _remainingTime;
  }

  String toTimeString() {
    if (representation == 0)
      return _remainingTime.inMinutes.toString() +
          ':' +
          (_remainingTime.inSeconds % 60).toString().padLeft(2, '0') +
          '.' +
          (_remainingTime.inMilliseconds % 1000)
              .toString()
              .padLeft(3, '0')
              .padLeft(2, '0');
    else if (representation == 1)
      return _remainingTime.inMinutes.toString() +
          ':' +
          (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    else
      return _remainingTime.inSeconds.toString();
  }

  void playAudio(String path) {
    if (kIsWeb) {
      js.context.callMethod('playAudio', [path]);
    }
  }
}
