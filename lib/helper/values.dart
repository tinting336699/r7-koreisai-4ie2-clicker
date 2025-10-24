import 'package:flutter/material.dart';

class ScoreHolder with ChangeNotifier {
  int _score = 0;
  int get score => _score;

  void setScore(int score) {
    _score = score;
    notifyListeners();
  }
}

class NameHolder with ChangeNotifier {
  String _name = "";
  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}
