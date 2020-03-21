class TeamInfo {
  int freeRugby = 5;
  int availableTryBall = 0;
  int availableScoreBall = 0;
  int score = 0;
  int retry = 0;
  int violation = 0;
  int availableKickBall = 0;
  int scoredSpot = 0;
  List<Function> undoAction = [];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> obj = {};
    obj['freeRugby'] = freeRugby;
    obj['availableTryBall'] = availableTryBall;
    obj['availableScoreBall'] = availableScoreBall;
    obj['score'] = score;
    obj['retry'] = retry;
    obj['violation'] = violation;
    obj['availableKickBall'] = availableKickBall;
    return obj;
  }
}
