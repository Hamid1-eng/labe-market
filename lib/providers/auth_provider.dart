import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;

  bool get isAuthenticated => user != null;

  void setUser(UserModel u) {
    user = u;
    notifyListeners();
  }

  void updatePhotoUrl(String url) {
    if (user != null) {
      user = UserModel(
        id: user!.id,
        name: user!.name,
        phone: user!.phone,
        photoUrl: url,
      );
      notifyListeners();
    }
  }
}
