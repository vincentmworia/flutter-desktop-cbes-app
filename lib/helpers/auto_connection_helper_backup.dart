import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/mqtt.dart';

Future<StreamSubscription<ConnectivityResult>?>internetChecker({
  required bool mounted,
  required Function updateUi,
  required Connectivity connectivity,
  required bool reInitializationActive,
  required BuildContext context,
}) async {
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
      connectivity.onConnectivityChanged.listen((result) async {
    print('222 $result');
    print(reInitializeConn);
    print(reInitializationActive );


    if (tempResult == null) {
      print('1');
      if (result == ConnectivityResult.none && reInitializationActive) {
        print('activate re-init');
        reInitializeConn = true;
      }
      updateUi(result);
      tempResult = result;
    }
    if (tempResult != result) {
      print('2');
      if (result == ConnectivityResult.none && reInitializationActive) {
        print('activate re-init');
        reInitializeConn = true;
      }
      if (reInitializeConn &&
          (result == ConnectivityResult.ethernet ||
              result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile)) {
        // todo perform re-initialization of the MQTT connection if in homepage 
        print('MQTT REINIT');
     Provider.of<MqttProvider>(context, listen: false)
            .initializeMqttClient();
        reInitializeConn = false;
      }

      print('5');
      updateUi(result);
      tempResult = result;
    }
  });
  return connectivitySubscription;
}
