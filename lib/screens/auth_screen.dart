import 'dart:async';

import 'package:flutter/services.dart';

import '../helpers/custom_data.dart';
import '../models/user.dart';
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
      // todo LOGIN LASTING FOR LONG
      Timer.run(() {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          print('STOP LOGIN PROCESS');
        });
      });
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
        // todo, If user is not allowed in the app, throw the error too
        Future.delayed(Duration.zero)
            .then((value) async => await customDialog(context, 'Login Failed'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = 15.0;

    final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi;
    final deviceWidth = MediaQuery.of(context).size.width;

    final bgImage = Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.grey,

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
              Visibility(
                visible: (goodConnection),
                child: Align(
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
              ),
              Visibility(
                visible: _isLoading,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              ),
              if (!goodConnection) const OfflineScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
