import 'package:flutter/material.dart';
import 'package:robocon_2020_timer/widget/ag_container.dart';
import 'package:robocon_2020_timer/widget/opacity_hero.dart';
import 'package:robocon_2020_timer/widget/opacity_route.dart';
import 'package:robocon_2020_timer/widget/timer_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(context, OpacityRoute(page: TimerPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AGContainer(
      begin: Colors.indigo[900],
      end: Colors.red[900],
      child: OpacityHero(
        opacity: 1.0,
        tag: 'logo',
        child: Image.asset(
          'assets/logo.png',
          width: 150,
        ),
      ),
    );
  }
}
