import 'package:cbesdesktop/models/loggedin.dart';
import 'package:flutter/foundation.dart';

class LoginUserData with ChangeNotifier {
  LoggedIn? _loggedInUser;

  // LoggedIn get loggedInUser => _loggedInUser!;
  static LoggedIn? getLoggedUser;

  void setLoggedInUser(LoggedIn loggedIn) {
    _loggedInUser = loggedIn;
    print(_loggedInUser?.firstname);
    getLoggedUser = loggedIn;
    notifyListeners();
  }

  void resetLoggedInUser() {
    _loggedInUser = null;
    // notifyListeners();
  }
}
