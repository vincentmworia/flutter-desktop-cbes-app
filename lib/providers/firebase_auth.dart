import 'dart:convert';

// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../private_data.dart';
import '../models/signup.dart';

class FirebaseAuthentication {
  static Uri _actionEndpointUrl(String action) => Uri.parse(
      "https://identitytoolkit.googleapis.com/v1/accounts:$action?key=$firebaseApiKey");

  // todo create a refresh token after every 1 hour

  static String _getErrorMessage(String errorTitle) {
    var message = 'Operation failed';

    if (errorTitle.contains('EMAIL_EXISTS')) {
      message = 'Email is already in use';
    }
    if (errorTitle.contains('CREDENTIAL_TOO_OLD_LOGIN_AGAIN')) {
      message = 'Select a new email';
    } else if (errorTitle.contains('INVALID_EMAIL')) {
      message = 'This is not a valid email address';
    } else if (errorTitle.contains('NOT_ALLOWED')) {
      message = 'User needs to be allowed by the admin';
    } else if (errorTitle.contains('TOO_MANY_ATTEMPTS_TRY_LATER:')) {
      message =
          'We have blocked all requests from this device due to unusual activity. Try again later.';
    } else if (errorTitle.contains('EMAIL_NOT_FOUND')) {
      message = 'Could not find a user with that email.';
    } else if (errorTitle.contains('WEAK_PASSWORD')) {
      message = 'Password must be at least 6 characters';
    } else if (errorTitle.contains('INVALID_PASSWORD')) {
      message = 'Invalid password';
    } else {
      message = message;
    }
    return message;
  }

  static Future<String> signUp(User user) async {
    String? message;
    final response = await http.post(_actionEndpointUrl("signUp"),
        body: json.encode({
          "email": user.email!,
          "password": user.password!,
          "returnSecureToken": true,
        }));
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData['error'] != null) {
      message = _getErrorMessage(responseData['error']['message']);
      return message;
    }
    final signedUpUser = SignUp.fromMap(responseData);
    user.localId = signedUpUser.localId;
    // todo user.autologin=false
    user.allowed = allowUserFalse;
    user.privilege = userGuest;

    await http.patch(
        Uri.parse('$firebaseDbUrl/users.json?auth=${signedUpUser.idToken}'),
        body: json.encode({
          signedUpUser.localId: user.toMap(),
        }));
    message =
        'Welcome,\n${user.firstName} ${user.lastName}';
    return message;
  }

  // static Future<String> signIn(User user) async {}
}
