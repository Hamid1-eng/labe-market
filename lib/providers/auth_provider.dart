import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;

  bool get isAuthenticated => user != null;

  void setUser(UserModel u) {
    user = u;
    notifyListeners();
  }
}
