import 'package:flutter/material.dart';
import 'package:robocon_2020_timer/widget/scoreboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HKUST robotics team robocon timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScoreBoard(),
    );
  }
}
