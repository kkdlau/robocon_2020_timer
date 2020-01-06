import 'package:flutter/material.dart';
import 'package:robocon_2020_timer/widget/timer_bar.dart';

class ScoreBoard extends StatefulWidget {
  ScoreBoard({Key key}) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  double width;

  @override
  void initState() {
    width = 1000;
    Future.delayed(Duration(seconds: 2), () {
      width = 0;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TimerBar(
                duration: const Duration(milliseconds: 1000),
                beignColor: Colors.green,
                endColor: Colors.red,
                width: width,
                height: 30,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
