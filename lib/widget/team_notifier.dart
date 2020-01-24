import 'package:flutter/material.dart';

class TeamNotifier with ChangeNotifier {
  List<DataRow> redTeamData;
  List<DataRow> blueTeamData;

  TeamNotifier({this.blueTeamData, this.redTeamData});

  update() {
    notifyListeners();
  }
}
