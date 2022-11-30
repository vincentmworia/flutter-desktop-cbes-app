import 'dart:async';
import 'dart:ui';

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

  void _submit(User user) {
    setState(() => _isLoading = true);
    print(user.toMap());
    print(user.autoLogin);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => setState(() => _isLoading = false));
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
    // final bgImage = Stack(
    //   children: [
    //     SizedBox(
    //       height: double.infinity,
    //       width: double.infinity,
    //       child: Image.asset(
    //         'images/home3.jpg',
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     Container(
    //       width: double.infinity,
    //       height: double.infinity,
    //       color: Theme.of(context)
    //           .colorScheme
    //           .primary
    //           .withOpacity(MyApp.appOpacity),
    //     ),
    //   ],
    // );
    // double _sigmaX = 6.0; // from 0-10
    double _sigmaY = 3.0; // from 0-10
    double _opacity = .85; // from 0-1.0
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
        filter: ImageFilter.blur(sigmaX: _sigmaY, sigmaY: _sigmaY),
        child: Container(
          color: Colors.black.withOpacity(_opacity),
        ),
      ),
    );

    if (kDebugMode) {
      print(_connectionStatus);
    }
    const borderRadius=15.0;
    return WindowsWrapper(
        child: LayoutBuilder(
      builder: (context, cons) => Stack(
        children: [
          bgImage,
          Visibility(
            visible: goodConnection,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: deviceWidth < 700 ? 700 * 0.425 : deviceWidth * 0.425,
                height: deviceHeight,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius),
                  ),
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.9),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.9),
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
