import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _customerId;

  int? get customerId => _customerId;

  void setCustomerId(int id) {
    _customerId = id;
    notifyListeners(); // thông báo khi có thay đổi
  }

  void clear() {
    _customerId = null;
    notifyListeners();
  }
}
