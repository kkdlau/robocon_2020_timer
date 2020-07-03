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
  bool called = false;
  bool _useJP = false;

  CountTimer({this.duration, this.representation}) {
    _remainingTime = duration;
  }

  void start({bool useJP = false}) {
    _useJP = useJP;
    final DateTime start = DateTime.now();
    _begin = start.add(Duration(milliseconds: 1000 - start.millisecond));
    _duration = this.duration;
    called = false;
    if (_duration.inSeconds == 63) {
      if (useJP)
        playAudio('before_one_min_jp.mp3');
      else
        playAudio('before_one_min.mp3');
    }
  }

  void updateDuration(Duration d) {
    _remainingTime = d;
    called = false;
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
    if (_remainingTime.inSeconds == 5 && !called) {
      playAudio('countdown_hk.mp3');
      called = true;
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
