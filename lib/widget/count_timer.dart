enum CountControl { countup, countdown }

class CountTimer {
  Duration duration;

  /// time string representation
  int representation = 0;

  /// the real duration.
  Duration _duration;
  CountControl control;
  DateTime _begin;
  Duration _remainingTime;
  bool pasued = false;

  CountTimer({this.duration, this.control = CountControl.countdown}) {
    _remainingTime = duration;
  }

  void start() {
    _begin = DateTime.now();
    _duration = this.duration;
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
}
