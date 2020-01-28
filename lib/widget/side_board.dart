import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ball.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/count_timer.dart';
import 'package:robocon_2020_timer/widget/team.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';

class SideBoard extends StatefulWidget {
  final Color teamColor;
  final bool renew;
  SideBoard({Key key, this.teamColor, this.renew}) : super(key: key);

  @override
  SideBoardState createState() => SideBoardState();
}

class SideBoardState extends State<SideBoard> {
  List<Widget> availableRugby() {
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);
    TeamInfo info;
    List<Widget> rugby = [Text('Available try ball: ')];
    if (widget.teamColor == Colors.red[900])
      info = team.redTeamInfo;
    else
      info = team.blueTeamInfo;
    for (int i = 0; i < info.freeRugby; i++) {
      rugby.add(Ball(
        color: Colors.white70,
      ));
    }
    for (int i = info.freeRugby; i < 5; i++) {
      rugby.add(Ball(
        fill: false,
        color: Colors.white70,
      ));
    }
    return rugby;
  }

  void informListener(String message) {
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);
    final Notifier<CountTimer> timerProvider =
        Provider.of<Notifier<CountTimer>>(context, listen: false);
    if (widget.teamColor == Colors.red[900]) {
      team.redTeamData.insert(
          0,
          DataRow(cells: <DataCell>[
            DataCell(Text(timerProvider.data.toTimeString())),
            DataCell(Text(message)),
          ]));
      team.redTeamLog.insert(0, [timerProvider.data.toTimeString(), message]);
    } else {
      team.blueTeamData.insert(
          0,
          DataRow(cells: <DataCell>[
            DataCell(Text(timerProvider.data.toTimeString())),
            DataCell(Text(message)),
          ]));
      team.blueTeamLog.insert(0, [timerProvider.data.toTimeString(), message]);
    }
    team.update();
  }

  void discordMessage() {
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);
    if (widget.teamColor == Colors.red[900]) {
      if (team.redTeamData.length > 1) team.redTeamData.removeAt(0);
    } else {
      if (team.blueTeamData.length > 1) team.blueTeamData.removeAt(0);
    }
    team.update();
  }

  @override
  Widget build(BuildContext context) {
    final Notifier<int> kickBallProvider = Provider.of<Notifier<int>>(context);
    final Notifier<GameState> gameState =
        Provider.of<Notifier<GameState>>(context);
    final TeamNotifier team = Provider.of<TeamNotifier>(context);
    TeamInfo info;
    if (widget.teamColor == Colors.red[900])
      info = team.redTeamInfo;
    else
      info = team.blueTeamInfo;
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(info.score.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .display4
                  .apply(color: Colors.white, fontFamily: 'BreeSerif')),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'R:' + info.retry.toString(),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              setState(() {
                                info.retry++;
                                informListener('Asked for retry.');
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Retry'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'V: ' + info.violation.toString(),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              setState(() {
                                info.violation++;
                                team.update();
                                informListener('Acted in violation.');
                              });
                            }
                          : null,
                      child: Text('Violation'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))
                ],
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: availableRugby(),
            crossAxisAlignment: WrapCrossAlignment.center,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              if (info.freeRugby > 0)
                                setState(() {
                                  info.freeRugby--;
                                  info.availableTryBall++;
                                  informListener('Got 1 try ball. Ramained: ' +
                                      info.freeRugby.toString());
                                  team.update();
                                });
                            }
                          : null,
                      child: Text('Got Try ball'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableTryBall > 0
                          ? () {
                              setState(() {
                                info.score++;
                                info.availableTryBall--;
                                info.availableScoreBall++;
                                informListener(
                                    'Received ball. Current Score: ' +
                                        info.score.toString());
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Received ball'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableScoreBall > 0
                          ? () {
                              setState(() {
                                info.score += 2;
                                info.scoredSpot += 1;
                                info.availableScoreBall--;
                                informListener(
                                    'Scored spots, got 2 points! Current score: ' +
                                        info.score.toString());
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Score spots'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    onPressed: gameState.data == GameState.Versus &&
                            info.scoredSpot > 0 &&
                            kickBallProvider.data > 0
                        ? () {
                            setState(() {
                              info.availableKickBall++;
                              info.scoredSpot--;
                              kickBallProvider
                                  .informListener(kickBallProvider.data - 1);
                              informListener('Got 1 kick ball. Remaining: ' +
                                  kickBallProvider.data.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Got kick ball'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlineButton(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    onPressed: gameState.data == GameState.Versus
                        ? () {
                            setState(() {
                              info.score += 10;
                              informListener(
                                  'Miss shooting from opponent. Current Score: ' +
                                      info.score.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Got opponent’s ball'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text('Kick ball at: '),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus &&
                          info.availableKickBall > 0
                      ? () {
                          setState(() {
                            info.score += 5;
                            info.availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z1. Current Score: ' +
                                    info.score.toString());
                            team.update();
                          });
                        }
                      : null,
                  child: Text('Z1'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus &&
                          info.availableKickBall > 0
                      ? () {
                          setState(() {
                            info.score += 10;
                            info.availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z2. Current Score: ' +
                                    info.score.toString());
                            team.update();
                          });
                        }
                      : null,
                  child: Text('Z2'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus &&
                          info.availableKickBall > 0
                      ? () {
                          setState(() {
                            info.score += 20;
                            info.availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z3. Current Score: ' +
                                    info.score.toString());
                            team.update();
                          });
                        }
                      : null,
                  child: Text('Z3'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus
                      ? discordMessage
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Icon(Icons.undo), Text(' Undo')],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)))
            ],
          )
        ],
      ),
    );
  }
}
