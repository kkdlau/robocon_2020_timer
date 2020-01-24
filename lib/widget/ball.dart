import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final bool fill;
  final Color color;
  const Ball({Key key, this.fill = true, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget ballBody;
    if (fill) {
      ballBody = Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10.0)),
        width: 20.0,
        height: 20.0,
      );
    } else {
      ballBody = Container(
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(10.0)),
        width: 20.0,
        height: 20.0,
      );
    }
    return Padding(padding: EdgeInsets.all(2.0), child: ballBody);
  }
}
