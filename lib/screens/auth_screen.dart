import 'dart:async';
import 'dart:ui';

import '../helpers/custom_data.dart';
import '../models/user.dart';
import '../widgets/auth_screen_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../widgets/windows_wrapper.dart';
import '../helpers/auto_connection_helper.dart';
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

  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void _updateInternetState(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  void _switchAuthMode(AuthMode authMode) {
    setState(() {
      _authMode = authMode;
      print(_authMode);
    });
  }

  void _submit(User user ) async {
    setState(() {
      _isLoading = true;
    });
    // Use provider to get the status of autologin, Use shared preferences api to autologin
    // print(user.autoLogin);

    if (_authMode == AuthMode.register) {
      await FirebaseAuthentication.signUp(user)
          .then((message) async => await customDialog(context, message))
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }
    if (_authMode == AuthMode.login) {
      Future.delayed(Duration.zero)
          .then((value) async => await FirebaseAuthentication.signIn(
                  user, context)
              .then((message) async => await customDialog(context, message)))
          .then((_) =>
              Navigator.pushReplacementNamed(context, HomeScreen.routeName));
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("AUTH INITIALIZATION");
    }

    Future.delayed(Duration.zero).then((value) async =>
        _connectivitySubscription = await internetChecker(
            mounted: mounted,
            updateUi: _updateInternetState,
            connectivity: _connectivity));
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('AUTH DISPOSED');
    }
    _connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    const opMain = 0.9;
    double sigma = 10; // from 0-10
    double opacity = 0.5; // from 0-1.0
    const borderRadius = 15.0;

    final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final bgImage = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,

      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Colors.white,
      //       Theme.of(context).colorScheme.secondary.withOpacity(opMain),
      //       Theme.of(context).colorScheme.primary.withOpacity(opMain),
      //     ],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      // child: BackdropFilter(
      //   filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      //   child: Container(
      //     color: Colors.black.withOpacity(opacity),
      //   ),
      // ),
    );

    return WindowsWrapper(
        child: LayoutBuilder(
      builder: (context, cons) => Stack(
        children: [
          bgImage,
          Visibility(
            visible: (goodConnection),
            child: Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width:deviceWidth <1200? deviceWidth * 0.55: deviceWidth * 0.45,
                height: _authMode == AuthMode.register
                    ? deviceHeight * 0.95
                    : deviceHeight * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: AuthScreenForm(
                    authMode: _authMode,
                    isLoading: _isLoading,
                    submit: _submit,
                    switchAuthMode: _switchAuthMode),
              ),
            ),
          ),
          if (!goodConnection) const OfflineScreen(),
        ],
      ),
    ));
  }
}
