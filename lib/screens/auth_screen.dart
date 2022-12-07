import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../helpers/custom_data.dart';
import '../models/user.dart';
import '../widgets/auth_screen_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../widgets/windows_wrapper.dart';
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
    // var activateReInitialization=false;
    _connectivity.onConnectivityChanged.listen((result) {
      tempResult ??= result;
      if (tempResult != result) {
        if(result ==ConnectionState.none){

        }
        _rebuildScreen(result);
        tempResult=result;
      }
    });
  }

  void _rebuildScreen(ConnectivityResult result) {
    if (mounted) {
      setState(() {
        _connectionStatus = result;
        print('rebuild $result');
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (kDebugMode) {
  //     print("AUTH INITIALIZATION");
  //   }
  //
  //   Future.delayed(Duration.zero).then(
  //       (value) async => _connectivitySubscription = await internetChecker(
  //             mounted: mounted,
  //             updateUi: _updateInternetState,
  //             connectivity: _connectivity,
  //             reInitializationActive: false,
  //             context: context,
  //           ));
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
    // Use provider to get the status of autologin, Use shared preferences api to autologin
    // print(user.autoLogin);

    if (_authMode == AuthMode.register) {
      // Future.delayed(const Duration(seconds: 10))
      //     .then((value) => print('Slow internet'));
      await FirebaseAuthentication.signUp(user).then((message) async =>
          await customDialog(context, message)).then((_) =>
          setState(() {
            _isLoading = false;
          }));
    }
    if (_authMode == AuthMode.login) {
      Future.delayed(Duration.zero).then((value) async =>
          await FirebaseAuthentication.signIn(user, context)
              .then((message) async {
            setState(() {
              _isLoading = false;
            });
            await customDialog(context, message);
            if (message.startsWith("Welcome")) {
              Future.delayed(Duration.zero).then((_) =>
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (_) => const TempHomePage())));
              Navigator.pushReplacementNamed(
                  context, HomeScreen.routeName));
            }
          }));
      // .then((_) =>
      //     Navigator.pushReplacementNamed(context, HomeScreen.routeName));
    }
  }

  @override
  Widget build(BuildContext context) {
    const opMain = 0.9;
    double sigma = 10; // from 0-10
    double opacity = 0; // from 0-1.0
    const borderRadius = 15.0;

    final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
        _connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi;
    // print(goodConnection);
    final deviceWidth = MediaQuery.of(context).size.width;

    final bgImage = Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.grey,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Theme.of(context).colorScheme.secondary.withOpacity(opMain),
            Theme.of(context).colorScheme.primary.withOpacity(opMain),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: Colors.black.withOpacity(opacity),
        ),
      ),
    );

    const bdRadius = BorderRadius.only(
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
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
    );
  }
}
