import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ball.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/count_timer.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';

class SideBoard extends StatefulWidget {
  final Color teamColor;
  SideBoard({Key key, this.teamColor}) : super(key: key);

  @override
  _SideBoardState createState() => _SideBoardState();
}

class _SideBoardState extends State<SideBoard> {
  int freeRugby;
  int availableTryBall = 0;
  int availableScoreBall = 0;
  int score = 0;
  int retry = 0;
  int violation = 0;
  int availableKickBall = 0;

  List<Object> action = [];
  @override
  void initState() {
    super.initState();
    freeRugby = 5;
  }

  List<Widget> availableRugby() {
    List<Widget> rugby = [Text('Available try ball: ')];
    for (int i = 0; i < freeRugby; i++) {
      rugby.add(Ball(
        color: Colors.white70,
      ));
    }
    for (int i = freeRugby; i < 5; i++) {
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
    if (widget.teamColor == Colors.red[900])
      team.redTeamData.insert(
          0,
          DataRow(cells: <DataCell>[
            DataCell(Text(timerProvider.data.toTimeString())),
            DataCell(Text(message)),
          ]));
    else
      team.blueTeamData.insert(
          0,
          DataRow(cells: <DataCell>[
            DataCell(Text(timerProvider.data.toTimeString())),
            DataCell(Text(message)),
          ]));
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
    final kickBallProvider = Provider.of<Notifier<int>>(context);
    final Notifier<GameState> gameState =
        Provider.of<Notifier<GameState>>(context);
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(score.toString(),
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
                    'R:' + retry.toString(),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              setState(() {
                                retry++;
                                informListener('Asked for retry.');
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
                    'V: ' + violation.toString(),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  OutlineButton(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      onPressed: gameState.data == GameState.Versus
                          ? () {
                              setState(() {
                                violation++;
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
                              if (freeRugby > 0)
                                setState(() {
                                  freeRugby--;
                                  availableTryBall++;
                                  informListener('Got 1 try ball. Ramained: ' +
                                      freeRugby.toString());
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
                              availableTryBall > 0
                          ? () {
                              setState(() {
                                score++;
                                availableTryBall--;
                                availableScoreBall++;
                                informListener(
                                    'Received ball. Current Score: ' +
                                        score.toString());
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
                              availableScoreBall > 0
                          ? () {
                              setState(() {
                                score += 2;
                                availableScoreBall--;
                                informListener(
                                    'Scored spots, got 2 points! Current score: ' +
                                        score.toString());
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
                    onPressed: gameState.data == GameState.Versus
                        ? () {
                            if (kickBallProvider.data > 0)
                              setState(() {
                                availableKickBall++;
                                kickBallProvider
                                    .informListener(kickBallProvider.data - 1);
                                informListener('Got 1 kick ball. Remaining: ' +
                                    kickBallProvider.data.toString());
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
                              score += 10;
                              informListener(
                                  'Miss shooting from opponent. Current Score: ' +
                                      score.toString());
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
                          availableKickBall > 0
                      ? () {
                          setState(() {
                            score += 5;
                            availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z1. Current Score: ' +
                                    score.toString());
                          });
                        }
                      : null,
                  child: Text('Z1'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus &&
                          availableKickBall > 0
                      ? () {
                          setState(() {
                            score += 10;
                            availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z2. Current Score: ' +
                                    score.toString());
                          });
                        }
                      : null,
                  child: Text('Z2'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  onPressed: gameState.data == GameState.Versus &&
                          availableKickBall > 0
                      ? () {
                          setState(() {
                            score += 20;
                            availableKickBall--;
                            informListener(
                                'Successfully kicked ball at Z3. Current Score: ' +
                                    score.toString());
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
