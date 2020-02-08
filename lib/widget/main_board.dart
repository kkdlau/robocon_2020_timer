import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ag_container.dart';
import 'package:robocon_2020_timer/widget/history_dialog.dart';
import 'package:robocon_2020_timer/widget/opacity_hero.dart';
import 'package:robocon_2020_timer/widget/side_board.dart';
import 'package:robocon_2020_timer/widget/team.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';

class MainBoard extends StatelessWidget {
  const MainBoard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Notifier<List<Color>> bgColor =
        Provider.of<Notifier<List<Color>>>(context);
    final TeamNotifier team = Provider.of<TeamNotifier>(context);
    final Notifier<int> kickBallProvider =
        Provider.of<Notifier<int>>(context, listen: false);
    final Notifier<GameState> gameStateProvider =
        Provider.of<Notifier<GameState>>(context);
    final Widget blueTeam = Expanded(
      child: SideBoard(
        teamColor: bgColor.data[0],
      ),
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
                        onPressed: gameStateProvider.data ==
                                    GameState.Waiting ||
                                gameStateProvider.data == GameState.End
                            ? () async {
                                String result = await showDialog(
                                    context: context, child: HistoryDialog());
                                if (result != null) {
                                  Map<String, dynamic> history =
                                      json.decode(result);
                                  kickBallProvider
                                      .informListener(history['kickBall']);
                                  team.redTeamInfo = TeamInfo();
                                  team.redTeamInfo
                                    ..availableKickBall =
                                        history['rt']['sb']['availableKickBall']
                                    ..availableScoreBall = history['rt']['sb']
                                        ['availableScoreBall']
                                    ..availableTryBall =
                                        history['rt']['sb']['availableTryBall']
                                    ..freeRugby =
                                        history['rt']['sb']['freeRugby']
                                    ..retry = history['rt']['sb']['retry']
                                    ..score = history['rt']['sb']['score']
                                    ..violation =
                                        history['rt']['sb']['violation'];
                                  team.blueTeamInfo = TeamInfo();
                                  team.blueTeamInfo
                                    ..availableKickBall =
                                        history['bt']['sb']['availableKickBall']
                                    ..availableScoreBall = history['bt']['sb']
                                        ['availableScoreBall']
                                    ..availableTryBall =
                                        history['bt']['sb']['availableTryBall']
                                    ..freeRugby =
                                        history['bt']['sb']['freeRugby']
                                    ..retry = history['bt']['sb']['retry']
                                    ..score = history['bt']['sb']['score']
                                    ..violation =
                                        history['bt']['sb']['violation'];
                                  team.redTeamData = [];
                                  team.redTeamLog = [];
                                  history['rt']['log'].forEach((f) {
                                    team.redTeamData.add(DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(f[0])),
                                          DataCell(Text(f[1]))
                                        ]));
                                    team.redTeamLog.add([f[0], f[1]]);
                                  });

                                  team.blueTeamLog = [];
                                  team.blueTeamData = [];
                                  history['bt']['log'].forEach((f) {
                                    team.blueTeamData.add(DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text(f[0])),
                                          DataCell(Text(f[1]))
                                        ]));
                                    team.blueTeamLog.add([f[0], f[1]]);
                                  });
                                  team.update();
                                }
                              }
                            : null,
                        icon: Icon(Icons.history),
                        label: Text('History'),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
