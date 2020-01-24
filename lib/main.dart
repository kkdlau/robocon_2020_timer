import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robocon_2020_timer/widget/change_notifier.dart';
import 'package:robocon_2020_timer/widget/count_timer.dart';
import 'package:robocon_2020_timer/widget/main_board.dart';
import 'package:robocon_2020_timer/widget/team_notifier.dart';
import 'package:robocon_2020_timer/widget/time_board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robocon timer',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        child: MainBoard(),
        providers: [
          ChangeNotifierProvider<Notifier<int>>(
            create: (_) => Notifier<int>(7), // Available kick ball
          ),
          ChangeNotifierProvider<Notifier<GameState>>(
            create: (_) => Notifier<GameState>(GameState.Waiting), // Game state
          ),
          ChangeNotifierProvider<TeamNotifier>(
              // Team table data
              create: (_) => TeamNotifier(redTeamData: [
                    DataRow(cells: <DataCell>[
                      DataCell(Text('---')),
                      DataCell(Text('Welcome to Robocon!'))
                    ])
                  ], blueTeamData: [
                    DataRow(cells: <DataCell>[
                      DataCell(Text('---')),
                      DataCell(Text('Welcome to Robocon!'))
                    ])
                  ])),
          ChangeNotifierProvider<Notifier<List<Color>>>(
            create: (_) => Notifier<List<Color>>(
                [Colors.indigo[900], Colors.red[900]]), // background color
          ),
          ChangeNotifierProvider<Notifier<CountTimer>>(
            create: (_) => Notifier<CountTimer>(null), // background color
          ),
        ],
      ),
    );
  }
}
