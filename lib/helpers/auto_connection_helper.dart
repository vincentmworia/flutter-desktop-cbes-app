import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<StreamSubscription<ConnectivityResult>?> internetChecker(
    {required bool mounted,
    required Function updateUi,
    required Connectivity connectivity}) async {
  try {
    Future.delayed(Duration.zero)
        .then((value) async => await connectivity.checkConnectivity());
  } on PlatformException catch (_) {
    if (kDebugMode) {
      print('Could n\'t check connectivity status');
    }
    return null;
  }
  if (!mounted) {
    return null;
  }
  ConnectivityResult? tempResult;
  var reInitializeConn = false;
  StreamSubscription<ConnectivityResult> connectivitySubscription =
      connectivity.onConnectivityChanged.listen((result) {
    if (tempResult == null) {
      updateUi(result);
      tempResult = result;
    }
    if (tempResult != result) {
      updateUi(result);
      tempResult = result;
      if (tempResult == ConnectivityResult.none) {
        reInitializeConn = true;
      }
      if (reInitializeConn &&
          (result == ConnectivityResult.ethernet ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile)) {
        // todo perform re-initialization of the MQTT connection
        reInitializeConn = false;
      }
    }
  });
  return connectivitySubscription;
}
