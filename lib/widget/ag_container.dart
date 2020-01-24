import 'package:flutter/material.dart';

class AGContainer extends StatefulWidget {
  final Color begin;
  final Color end;
  final Widget child;
  AGContainer({Key key, this.begin, this.end, this.child}) : super(key: key);

  @override
  _AGContainerState createState() => _AGContainerState();
}

class _AGContainerState extends State<AGContainer> {
  Color _begin;
  Color _end;
  @override
  void initState() {
    super.initState();
    _begin = widget.begin;
    _end = widget.end;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      builder: (BuildContext context, lv, Widget child) {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 1000),
          tween: ColorTween(begin: _end, end: widget.end),
          builder: (BuildContext context, dynamic rv, Widget child) {
            return Container(
                child: widget.child,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [lv, rv])));
          },
        );
      },
      duration: const Duration(milliseconds: 1000),
      tween: ColorTween(begin: _begin, end: widget.begin),
    );
  }
}
