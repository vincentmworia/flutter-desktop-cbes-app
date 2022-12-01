import 'dart:async';
import 'dart:ui';

import 'package:cbesdesktop/providers/firebase_auth.dart';

import '../helpers/custom_data.dart';
import '../main.dart';
import '../models/user.dart';
import '../widgets/auth_screen_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../widgets/windows_wrapper.dart';
import '../helpers/auto_connection_helper.dart';
import 'offline_screen.dart';

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

  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void _updateInternetState(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  void _submit(User user, AuthMode authMode) async {
    setState(() => _isLoading = true);
    print(user.toMap());
    // Use provider to get the status of autologin, Use shared preferences api to autologin
    // print(user.autoLogin);
    if (authMode == AuthMode.register) {
      await FirebaseAuthentication.signUp(user)
          .then((message) async => await customDialog(context, message));
    }
    if (authMode == AuthMode.login) {
      Future.delayed(Duration.zero).then((value) async =>
          await FirebaseAuthentication.signIn(user, context)
              .then((message) async => await customDialog(context, message)));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("AUTH INITIALIZATION");
    }
    internetChecker(
        mounted: mounted,
        updateUi: _updateInternetState,
        connectivity: _connectivity);
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('AUTH DISPOSED');
    }
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    const opMain = 0.9;
    final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    // todo remove print statement
    if (kDebugMode) {
      print(deviceWidth);
    }
    double sigma = 3.0; // from 0-10
    double opacity = 0.8; // from 0-1.0
    final bgImage = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: Colors.black.withOpacity(opacity),
        ),
      ),
    );

    if (kDebugMode) {
      print(_connectionStatus);
    }
    const borderRadius = 15.0;
    return WindowsWrapper(
        child: LayoutBuilder(
      builder: (context, cons) => Stack(
        children: [
          bgImage,
          Visibility(
            visible: goodConnection,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: deviceWidth * 0.45,
                height: deviceHeight,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    // topRight: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                    // bottomRight: Radius.circular(borderRadius),
                  ),
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(opMain),
                    Theme.of(context).colorScheme.secondary.withOpacity(opMain),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                padding: const EdgeInsets.all(8),
                child: AuthScreenForm(
                    authMode: _authMode,
                    isLoading: _isLoading,
                    submit: _submit),
              ),
            ),
          ),
          if (!goodConnection) const OfflineScreen(),
        ],
      ),
    ));
  }
}
