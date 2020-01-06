import 'package:flutter/material.dart';

class TimerBar extends StatefulWidget {
  final double width;
  final double height;
  final Duration duration;
  final Color beignColor;
  final Color endColor;
  TimerBar(
      {Key key,
      this.width,
      this.height,
      this.duration,
      this.beignColor,
      this.endColor})
      : super(key: key);

  @override
  _TimerBarState createState() => _TimerBarState();
}

class _TimerBarState extends State<TimerBar> {
  double _width;
  ColorTween _colorAnimation;
  @override
  void initState() {
    _width = widget.width;
    _colorAnimation =
        ColorTween(end: widget.beignColor, begin: widget.endColor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      builder: (BuildContext context, value, Widget child) {
        return Container(
          width: value,
          height: widget.height,
          decoration: BoxDecoration(
              color: _colorAnimation.transform(widget.width / _width),
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(widget.height / 2)),
        );
      },
      duration: widget.duration,
      tween: Tween(begin: _width, end: widget.width),
    );
  }
}
