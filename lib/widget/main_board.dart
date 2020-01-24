import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ag_container.dart';
import 'package:robocon_2020_timer/widget/opacity_hero.dart';
import 'package:robocon_2020_timer/widget/side_board.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'dart:html' as html;

class MainBoard extends StatelessWidget {
  const MainBoard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Notifier<List<Color>> bgColor =
        Provider.of<Notifier<List<Color>>>(context);
    final Widget blueTeam = Expanded(
      child: SideBoard(teamColor: bgColor.data[0]),
    );
    final Widget redTeam = Expanded(
      child: SideBoard(
        teamColor: bgColor.data[1],
      ),
    );
    return AGContainer(
      begin: bgColor.data[0],
      end: bgColor.data[1],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          List<Widget> rowChild = [blueTeam, Expanded(child: TimeBoard())];
          if (constraints.maxWidth / constraints.maxHeight > 1.5)
            rowChild.add(redTeam);
          return Material(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: OpacityHero(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 150,
                      ),
                      tag: 'logo',
                    ),
                  ),
                  Row(
                    children: rowChild,
                  ),
                  Positioned.fill(
                    child: Align(
                      child: FlatButton.icon(
                        onPressed: () {
                          html.window.open(
                              'https://github.com/kkdlau/robocon_2020_timer/issues',
                              '');
                        },
                        icon: Icon(Icons.report_problem),
                        label: Text('Report bugs / suggestions'),
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }
}
