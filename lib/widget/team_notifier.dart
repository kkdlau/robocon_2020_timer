import 'package:flutter/material.dart';
import 'package:robocon_2020_timer/widget/team.dart';

class TeamNotifier with ChangeNotifier {
  List<DataRow> redTeamData;
  List<DataRow> blueTeamData;
  TeamInfo redTeamInfo = TeamInfo();
  TeamInfo blueTeamInfo = TeamInfo();

  TeamNotifier({this.blueTeamData, this.redTeamData});

  update() {
    notifyListeners();
  }
}
