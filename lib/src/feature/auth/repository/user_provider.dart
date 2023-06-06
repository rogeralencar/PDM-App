import 'package:flutter/material.dart';

import 'user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<Map<String, dynamic>>? getUser() {
    if (_user != null) {
      return _user!.getUser();
    }
    return null;
  }
}
