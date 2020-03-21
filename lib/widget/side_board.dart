import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ball.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/count_timer.dart';
import 'package:robocon_2020_timer/widget/team.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';
import 'package:robocon_2020_timer/widget/white_outline_btn.dart';

class SideBoard extends StatefulWidget {
  final Color teamColor;
  final bool renew;
  SideBoard({Key key, this.teamColor, this.renew}) : super(key: key);

  @override
  SideBoardState createState() => SideBoardState();
}

class SideBoardState extends State<SideBoard> {
  bool _retrying;

  @override
  void initState() {
    super.initState();
    _retrying = false;
  }

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

  void discordAction() {
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);
    if (widget.teamColor == Colors.red[900]) {
      if (team.redTeamData.length > 1) {
        team.redTeamData.removeAt(0);
        team.redTeamInfo.undoAction.removeLast()();
      }
    } else {
      if (team.blueTeamData.length > 1) {
        team.blueTeamData.removeAt(0);
        team.blueTeamInfo.undoAction.removeLast()();
      }
    }
    team.update();
  }

  List<Widget> kickBallList(TeamInfo info) {
    List<Widget> rugby = [Text('Team available kick ball: ')];

    for (int i = 0; i < info.scoredSpot; i++) {
      rugby.add(Ball(color: Colors.yellow[700]));
    }

    for (int i = info.scoredSpot; i < 5; i++) {
      rugby.add(Ball(fill: false, color: Colors.yellow[700]));
    }
    return rugby;
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
                  .headline1
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
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  WOutlineButton(
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              if (!_retrying) {
                                setState(() {
                                  _retrying = true;
                                  info.retry++;
                                  info.undoAction.add(() {
                                    _retrying = false;
                                    info.retry--;
                                  });
                                  informListener('Asked for retry.');
                                  team.update();
                                });
                              } else {
                                setState(() {
                                  _retrying = false;
                                  info.undoAction.add(() {
                                    _retrying = true;
                                  });
                                  informListener(
                                      'Game start after aksed for retry.');
                                  team.update();
                                });
                              }
                            }
                          : null,
                      child: !_retrying ? Text('Retry') : Text('Start')),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  WOutlineButton(
                    onPressed: gameState.data == GameState.Versus &&
                            info.freeRugby != 5 &&
                            _retrying
                        ? () {
                            setState(() {
                              info.freeRugby++;
                              info.undoAction.add(() {
                                info.freeRugby--;
                              });
                              informListener(
                                  'Places try balls back to the rack. Current try ball: ' +
                                      info.freeRugby.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Add try ball'),
                  ),
                  WOutlineButton(
                      onPressed: gameState.data == GameState.Versus && _retrying
                          ? () {
                              setState(() {
                                info.availableKickBall++;
                                info.undoAction.add(() {
                                  info.availableKickBall--;
                                });
                                team.update();
                                informListener(
                                    'Places kick balls back to the tee. Current kick ball: ' +
                                        info.availableKickBall.toString());
                              });
                            }
                          : null,
                      child: Text('Add kick ball'))
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'V: ' + info.violation.toString(),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  WOutlineButton(
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              setState(() {
                                info.violation++;
                                info.undoAction.add(() {
                                  info.violation--;
                                });
                                team.update();
                                informListener('Acted in violation.');
                              });
                            }
                          : null,
                      child: Text('Violation'))
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
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              if (info.freeRugby > 0)
                                setState(() {
                                  info.freeRugby--;
                                  info.availableTryBall++;
                                  info.undoAction.add(() {
                                    info.freeRugby++;
                                    info.availableTryBall--;
                                  });
                                  informListener('Got 1 try ball. Ramained: ' +
                                      info.freeRugby.toString());
                                  team.update();
                                });
                            }
                          : null,
                      child: Text('Get try ball'))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableTryBall > 0
                          ? () {
                              setState(() {
                                info.score++;
                                info.availableTryBall--;
                                info.availableScoreBall++;
                                info.undoAction.add(() {
                                  info.score--;
                                  info.availableTryBall++;
                                  info.availableScoreBall--;
                                });
                                informListener(
                                    'Received ball. Current Score: ' +
                                        info.score.toString());
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Receive ball'))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableScoreBall > 0
                          ? () {
                              setState(() {
                                info.score += 2;
                                info.scoredSpot++;
                                info.availableScoreBall--;
                                info.undoAction.add(() {
                                  info.score -= 2;
                                  info.scoredSpot--;
                                  info.availableScoreBall++;
                                });
                                informListener(
                                    'Scored spots, got 2 points! Current score: ' +
                                        info.score.toString());
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Score spots')))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              if (info.freeRugby > 0)
                                setState(() {
                                  info.freeRugby--;
                                  info.undoAction.add(() {
                                    info.freeRugby++;
                                  });
                                  informListener('Failed to get try ball');
                                  team.update();
                                });
                            }
                          : null,
                      child: Text('Fail: Get try ball'))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableTryBall > 0
                          ? () {
                              setState(() {
                                info.availableTryBall--;
                                info.undoAction.add(() {
                                  info.availableTryBall++;
                                });
                                informListener('Failed to receive try ball.');
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Fail: Receive'))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  child: WOutlineButton(
                      onPressed: gameState.data == GameState.Versus &&
                              info.availableScoreBall > 0
                          ? () {
                              setState(() {
                                info.availableScoreBall--;
                                info.undoAction.add(() {
                                  info.availableScoreBall++;
                                });
                                informListener('Failed to score spots.');
                                team.update();
                              });
                            }
                          : null,
                      child: Text('Fail: Score spots')))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              children: kickBallList(info),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus &&
                            info.scoredSpot > 0 &&
                            kickBallProvider.data > 0 &&
                            info.availableKickBall < 3
                        ? () {
                            setState(() {
                              info.availableKickBall++;
                              info.scoredSpot--;
                              kickBallProvider
                                  .informListener(kickBallProvider.data - 1);
                              info.undoAction.add(() {
                                info.availableKickBall--;
                                info.scoredSpot++;
                                kickBallProvider
                                    .informListener(kickBallProvider.data + 1);
                              });
                              informListener('Got 1 kick ball. Remaining: ' +
                                  kickBallProvider.data.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Get kick ball')),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus
                        ? () {
                            setState(() {
                              info.score += 10;
                              info.undoAction.add(() {
                                info.score -= 10;
                              });
                              informListener(
                                  'Miss shooting from opponent. Current Score: ' +
                                      info.score.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Get opponent’s ball')),
              )
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text('Kick ball at: '),
              Tooltip(
                message: '5 points',
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus &&
                            info.availableKickBall > 0
                        ? () {
                            setState(() {
                              info.scoredSpot--;
                              info.score += 5;
                              info.availableKickBall--;
                              info.undoAction.add(() {
                                info.scoredSpot++;
                                info.score -= 5;
                                info.availableKickBall++;
                              });
                              informListener(
                                  'Successfully kicked ball at Z3. Current Score: ' +
                                      info.score.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Z1')),
              ),
              Tooltip(
                message: '10 points',
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus &&
                            info.availableKickBall > 0
                        ? () {
                            setState(() {
                              info.scoredSpot--;
                              info.score += 10;
                              info.availableKickBall--;
                              info.undoAction.add(() {
                                info.scoredSpot++;
                                info.score -= 10;
                                info.availableKickBall++;
                              });
                              informListener(
                                  'Successfully kicked ball at Z3. Current Score: ' +
                                      info.score.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Z2')),
              ),
              Tooltip(
                message: '20 points',
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus &&
                            info.availableKickBall > 0
                        ? () {
                            setState(() {
                              info.scoredSpot--;
                              info.score += 20;
                              info.availableKickBall--;
                              info.undoAction.add(() {
                                info.scoredSpot++;
                                info.score -= 20;
                                info.availableKickBall++;
                              });
                              informListener(
                                  'Successfully kicked ball at Z3. Current Score: ' +
                                      info.score.toString());
                              team.update();
                            });
                          }
                        : null,
                    child: Text('Z3')),
              ),
              WOutlineButton(
                  onPressed: gameState.data == GameState.Versus &&
                          info.availableKickBall > 0
                      ? () {
                          setState(() {
                            info.scoredSpot--;
                            info.availableKickBall--;
                            informListener('Failed to kick.');
                            team.update();
                          });
                        }
                      : null,
                  child: Text('Fail'))
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: UnconstrainedBox(
                child: WOutlineButton(
                    onPressed: gameState.data == GameState.Versus
                        ? discordAction
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[Icon(Icons.undo), Text(' Undo')],
                    ))),
          )
        ],
      ),
    );
  }
}
