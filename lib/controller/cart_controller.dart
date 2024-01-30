import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  List carts = [];

  addList({required dynamic value}) {
    carts.add(value);
  }

  deleteItem({required int index}) {
    carts.removeAt(index);
    notifyListeners();
  }
}
