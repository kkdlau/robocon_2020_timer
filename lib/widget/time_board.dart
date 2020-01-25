import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/ball.dart';
import 'package:robocon_2020_timer/widget/count_timer.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/side_board.dart';
import 'package:robocon_2020_timer/widget/team.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';

enum GameState { Preparation, Versus, Waiting }

class TimeBoard extends StatefulWidget {
  final GlobalKey blue;
  final GlobalKey red;
  TimeBoard({Key key, this.blue, this.red}) : super(key: key);

  @override
  _TimeBoardState createState() => _TimeBoardState();
}

class _TimeBoardState extends State<TimeBoard> {
  int _select = 0;
  CountTimer timer;
  String timePrint;
  Duration presentTime = Duration(milliseconds: 0);

  bool canStart = true;
  bool canPause = true;
  bool _oneMinutePre = true;

  @override
  void initState() {
    super.initState();
    timer = CountTimer(duration: Duration(minutes: 1));
    presentTime = Duration(minutes: 1);
    timePrint = timer.toTimeString();
  }

  void startTimer(Duration time, GameState state) {
    timer = CountTimer(duration: time);
    final Notifier<GameState> gameStateProvider =
        Provider.of<Notifier<GameState>>(context, listen: false);
    final Notifier<CountTimer> timerProvider =
        Provider.of<Notifier<CountTimer>>(context, listen: false);
    final Notifier<int> kickBall =
        Provider.of<Notifier<int>>(context, listen: false);
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);
    setState(() {
      print(GlobalKey<SideBoardState>().currentState);
      team.blueTeamData = [
        DataRow(cells: <DataCell>[
          DataCell(Text('---')),
          DataCell(Text('Welcome to Robocon 2020!'))
        ])
      ];
      team.redTeamData = [
        DataRow(cells: <DataCell>[
          DataCell(Text('---')),
          DataCell(Text('Welcome to Robocon 2020!'))
        ])
      ];
      team.redTeamInfo = TeamInfo();
      team.blueTeamInfo = TeamInfo();
      team.update();
      kickBall.informListener(7);
      timerProvider.informListener(timer);
      gameStateProvider.informListener(state);
      canPause = true;
      canStart = false;
    });
    timer.start();
    SchedulerBinding.instance.addPostFrameCallback(updateTimer);
  }

  void pauseTimer() {
    timer.pause();
    setState(() {
      canPause = false;
      canStart = true;
    });
  }

  void resumeTimer() {
    timer.resume();
    setState(() {
      canPause = true;
      canStart = false;
    });
    SchedulerBinding.instance.addPostFrameCallback(updateTimer);
  }

  void updateTimer(Duration d) {
    Duration passed = timer.update();
    final Notifier<GameState> gameStateProvider =
        Provider.of<Notifier<GameState>>(context, listen: false);
    if (passed.isNegative) {
      if (gameStateProvider.data == GameState.Versus) {
        timer = CountTimer(duration: Duration(seconds: 0));
        setState(() {
          gameStateProvider.informListener(GameState.Waiting);
          canStart = true;
          canPause = false;
          timePrint = timer.toTimeString();
        });
      } else {
        gameStateProvider.informListener(GameState.Versus);
        startTimer(Duration(minutes: 3), GameState.Versus);
      }
    } else {
      setState(() {
        timePrint = timer.toTimeString();
      });
      if (!timer.pasued)
        SchedulerBinding.instance.addPostFrameCallback(updateTimer);
    }
  }

  List<DataRow> getTableContent(Map<String, String> content) {
    List<DataRow> table = [];
    content.forEach((String time, String event) => table.add(DataRow(
        cells: <DataCell>[DataCell(Text(time)), DataCell(Text(event))])));

    return table;
  }

  List<Widget> kickBallList() {
    List<Widget> rugby = [Text('Available kick ball: ')];
    final Notifier<int> kickBallProvider =
        Provider.of<Notifier<int>>(context, listen: false);

    for (int i = 0; i < kickBallProvider.data; i++) {
      rugby.add(Ball(color: Colors.yellow[700]));
    }

    for (int i = kickBallProvider.data; i < 7; i++) {
      rugby.add(Ball(fill: false, color: Colors.yellow[700]));
    }
    return rugby;
  }

  @override
  Widget build(BuildContext context) {
    final Notifier<List<Color>> bgColor =
        Provider.of<Notifier<List<Color>>>(context);
    final TeamNotifier team = Provider.of<TeamNotifier>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(timePrint,
              style: Theme.of(context)
                  .textTheme
                  .display4
                  .apply(color: Colors.white, fontFamily: 'BreeSerif')),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OutlineButton(
                borderSide: BorderSide(color: Colors.white70, width: 2.0),
                child: Text('Start'),
                onPressed: canStart
                    ? () {
                        if (_oneMinutePre)
                          startTimer(
                              Duration(minutes: 1), GameState.Preparation);
                        else
                          startTimer(Duration(minutes: 3), GameState.Versus);
                      }
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            SizedBox(
              width: 20.0,
            ),
            OutlineButton(
                textColor: Colors.white70,
                borderSide: BorderSide(color: Colors.white70, width: 2.0),
                child: canPause ? Text('Pause') : Text('Resume'),
                onPressed: canStart && !timer.pasued
                    ? null
                    : canPause ? pauseTimer : resumeTimer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            SizedBox(
              width: 20.0,
            ),
            OutlineButton(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                onPressed: () {
                  if (bgColor.data[0] == Colors.red[900])
                    bgColor
                        .informListener([Colors.indigo[900], Colors.red[900]]);
                  else
                    bgColor
                        .informListener([Colors.red[900], Colors.indigo[900]]);

                  List<DataRow> temporary = team.redTeamData;
                  team.redTeamData = team.blueTeamData;
                  team.blueTeamData = temporary;
                  team.update();
                },
                child: Text('Reverse color'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('MSm:'),
            Radio(
              groupValue: _select,
              value: 0,
              onChanged: (int index) {
                setState(() {
                  _select = index;
                  timer.representation = index;
                  timePrint = timer.toTimeString();
                });
              },
            ),
            Text('ms:'),
            Radio(
              groupValue: _select,
              value: 1,
              onChanged: (int index) {
                setState(() {
                  _select = index;
                  timer.representation = index;
                  timePrint = timer.toTimeString();
                });
              },
            ),
            Text('s:'),
            Radio(
              groupValue: _select,
              value: 2,
              onChanged: (int index) {
                setState(() {
                  _select = index;
                  timer.representation = index;
                  timePrint = timer.toTimeString();
                });
              },
            ),
            Text('1 minute preparation: '),
            Checkbox(
              onChanged: (bool value) {
                if (timer.pasued) return;
                setState(() {
                  _oneMinutePre = value;
                  if (_oneMinutePre)
                    presentTime = Duration(minutes: 1);
                  else
                    presentTime = Duration(minutes: 3);
                  timePrint = timer.toTimeString();
                });
              },
              value: _oneMinutePre,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: kickBallList(),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 6.0, right: 6.0),
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(10.0)),
          child: Text('Blue team',
              style: TextStyle(color: Colors.blue, fontFamily: 'BreeSerif')),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowHeight: 30.0,
              columns: <DataColumn>[
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Event'))
              ],
              rows: team.blueTeamData,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            padding: EdgeInsets.only(left: 6.0, right: 6.0),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text('Red team',
                style: TextStyle(color: Colors.red, fontFamily: 'BreeSerif')),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowHeight: 30.0,
              columns: <DataColumn>[
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Event'))
              ],
              rows: team.redTeamData,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: OutlineButton(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    onPressed: null,
                    child: Text('Upload to server (Coming soon)'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))))
          ],
        )
      ],
    );
  }
}
