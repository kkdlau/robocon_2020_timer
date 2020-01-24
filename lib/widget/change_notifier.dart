import 'package:flutter/material.dart';

class Notifier<T> with ChangeNotifier {
  T _data;

  Notifier(this._data);

  T get data => _data;

  informListener(T data) async {
    _data = data;
    notifyListeners();
  }
}
