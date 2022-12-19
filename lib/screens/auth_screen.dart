import 'dart:async';
import 'dart:convert';

import 'package:cbesdesktop/models/logged_in.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_data.dart';
import '../models/user.dart';
import '../providers/login_user_data.dart';
import '../widgets/auth_screen_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../providers/firebase_auth.dart';
import './home_screen.dart';
import './offline_screen.dart';

enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  var init = true;
  var _authMode = AuthMode.login;

  ConnectivityResult _connectionStatus = ConnectivityResult.ethernet;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // todo Check whether autologin is activated,
    //  todo if so, directly move to the dashboard screen
    if (kDebugMode) {
      print(" AUTH INITIALIZATION");
    }

    try {
      Future.delayed(Duration.zero)
          .then((value) async => await _connectivity.checkConnectivity())
          .then((value) => setState(() {
                _connectionStatus = value;
              }));
    } on PlatformException catch (_) {
      if (kDebugMode) {
        print('Could n\'t check connectivity status');
      }
      return;
    }
    ConnectivityResult? tempResult;
    _connectivity.onConnectivityChanged.listen((result) {
      tempResult ??= result;
      if (tempResult != result) {
        if (result == ConnectionState.none) {}
        _rebuildScreen(result);
        tempResult = result;
      }
    });
  }

  void _rebuildScreen(ConnectivityResult result) {
    if (mounted) {
      setState(() {
        _connectionStatus = result;
      });
    }
  }
  //
  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   if (init) {
  //     final prefs = await SharedPreferences.getInstance();
  //     if (prefs.containsKey('loggedInUser')) {
  //       final loggedIn = prefs.getString('loggedInUser');
  //
  //       Future.delayed(Duration.zero).then((_) {
  //
  //         Provider.of<LoginUserData>(context, listen: false)
  //             .setLoggedInUser(LoggedIn.fromMap(json.decode(loggedIn!)));
  //         Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  //       });
  //     }
  //
  //     init = false;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('AUTH DISPOSED');
    }
    _connectivitySubscription?.cancel();
  }

  void _switchAuthMode(AuthMode authMode) {
    setState(() {
      _authMode = authMode;
    });
  }

  void _submit(User user) async {
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.register) {
      // todo try catch this
      try {
        await FirebaseAuthentication.signUp(user)
            .then((message) async => await customDialog(context, message))
            .then((_) => setState(() {
                  _isLoading = false;
                }));
      } catch (e) {
        await customDialog(context, 'Signing Up Failed');
      }
    }
    if (_authMode == AuthMode.login) {
      try {
        Future.delayed(Duration.zero).then((value) async =>
            await FirebaseAuthentication.signIn(user, context)
                .then((message) async {
              setState(() {
                _isLoading = false;
              });
              await customDialog(context, message);
              if (message.startsWith("Welcome")) {
                Future.delayed(Duration.zero).then((_) =>
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName));
              }
            }));
      } catch (e) {
        Future.delayed(Duration.zero)
            .then((value) async => await customDialog(context, 'Login Failed'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
      });
    }
    const borderRadius = 15.0;

    final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi;
    final deviceWidth = MediaQuery.of(context).size.width;

    final bgImage = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    const bdRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, cons) => Stack(
            children: [
              bgImage,
              Align(
                alignment: Alignment.center,
                child: Card(
                  elevation: 20,
                  shape: const RoundedRectangleBorder(borderRadius: bdRadius),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: deviceWidth < 1200
                        ? deviceWidth * 0.55
                        : deviceWidth * 0.45,
                    height: _authMode == AuthMode.register ? 1200 : 550,
                    decoration: BoxDecoration(
                        color: _isLoading
                            ? Colors.white.withOpacity(0.4)
                            : Colors.white,
                        borderRadius: bdRadius),
                    padding: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AuthScreenForm(
                          authMode: _authMode,
                          isLoading: _isLoading,
                          submit: _submit,
                          switchAuthMode: _switchAuthMode),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              ),
              if (!goodConnection)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  child: Center(
                    child: Text(
                      "OFFLINE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing:
                              MediaQuery.of(context).size.width * 0.035,
                          fontSize: MediaQuery.of(context).size.width * 0.075,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
