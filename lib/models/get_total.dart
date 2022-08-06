import 'package:flutter/material.dart';

class GetTotal extends ChangeNotifier {
  int _total = 0;

  int get totalPrice => _total;

  void add(int price) {
    _total += price;

    notifyListeners();
  }

  void reset() {
    _total = 0;

    notifyListeners();
  }
}
