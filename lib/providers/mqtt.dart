import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cbesdesktop/models/heating_unit.dart';
import 'package:cbesdesktop/providers/login_user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';

import '../private_data.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

// todo subscribe to all mqtt channels
class MqttProvider with ChangeNotifier {
  late MqttServerClient _mqttClient;

  MqttServerClient get mqttClient => _mqttClient;

  String get willTopic => _devicesClient;

  String get willMessage => _devicesClientMessage;

  HeatingUnit get heatingUnitData => _heatingUnitData!;
  HeatingUnit? _heatingUnitData;

  // todo set unique Id for individual devices? From Email?

  static final platform = Platform.isAndroid
      ? "Android"
      : Platform.isWindows
          ? "Windows"
          : Platform.isFuchsia
              ? "Fuchsia"
              : Platform.isIOS
                  ? "IOS"
                  : Platform.isLinux
                      ? "Linux"
                      : "Unknown Operating System";

  static final String deviceId = LoginUserData.getLoggedUser!.email;
  static final String _devicesClient = 'cbes/dekut/devices/$platform/$deviceId';
  static const String _devicesClientMessage = 'Disconnected Well';

  // todo If disconnected, nullify the token and forcefully logout the user

  Future<ConnectionStatus> initializeMqttClient() async {
    var connectionStatus = ConnectionStatus.disconnected;

    _mqttClient = MqttServerClient.withPort(
        mqttHost, 'flutter_client/$deviceId', mqttPort);
    _mqttClient.secure = true;
    _mqttClient.securityContext = SecurityContext.defaultContext;
    _mqttClient.keepAlivePeriod = 20;
    _mqttClient.onConnected = onConnected;
    _mqttClient.onDisconnected = onDisconnected;
    // _mqttClient.onSubscribed = onSubscribed;
    // _mqttClient.onUnsubscribed = onUnsubscribed;
    // _mqttClient.onSubscribed = onSubscribed;
    // _mqttClient.onSubscribeFail = onSubscribeFail;
    // _mqttClient.pongCallback = pong;

    _mqttClient.keepAlivePeriod = 60;

    final connMessage = MqttConnectMessage()
        .authenticateAs(mqttUsername, mqttPassword)
        .withWillTopic(_devicesClient)
        .withWillMessage('Disconnected Unexpected')
        .withWillRetain()
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);
    _mqttClient.connectionMessage = connMessage;

    _mqttClient.secure = true;
    _mqttClient.securityContext = SecurityContext.defaultContext;

    try {
      if (kDebugMode) {
        print("Connecting");
      }

      await _mqttClient.connect();
      connectionStatus = ConnectionStatus.connected;
    } catch (e) {
      if (kDebugMode) {
        print('\n\nException: $e');
      }
      _mqttClient.disconnect();
      connectionStatus = ConnectionStatus.disconnected;
    }
    if (connectionStatus == ConnectionStatus.connected) {
      _mqttClient.subscribe("cbes/dekut/#", MqttQos.exactlyOnce);

      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        var message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        if (topic == "cbes/dekut/heating_unit") {
          _heatingUnitData =
              HeatingUnit.fromMap(json.decode(message) as Map<String, dynamic>);

          print(_heatingUnitData);
        }

        if (topic == "cbes/dekut/devices/#") {
          // todo Get all the devices status and display in the UI,
          //  Disconnected or connected,
          // todo Record in firebase how long a user is logged in or logged out?
        }
      });
    }

    return connectionStatus;
  }

  void publishMsg(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (kDebugMode) {
      print('Publishing message "$message" to topic $topic');
    }
    _mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
  }

  void onConnected() {
    if (kDebugMode) {
      publishMsg(_devicesClient, 'Connected');
    }
  }

  void onDisconnected() {
    if (kDebugMode) {
      print('Disconnected');
      // TODO ON DISCONNECTED, FORCE THE USER OFFLINE
      // Use firebase Auth to force the application to HomePage
    }
  }
}
