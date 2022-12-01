import 'dart:async';
import 'dart:io';

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

  Map get heatingUnitData => _heatingUnitData;
  Map _heatingUnitData = {
    "tank1": "0",
    "tank2": "0",
    "tank3": "0",
    "flow1": "0",
    "flow2": "0",
  };

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
  static final String _devicesClientMessage = '$deviceId disconnected well';

  // todo If disconnected, nullify the token and forcefully logout the user

  Future<ConnectionStatus> initializeMqttClient() async {
    var connectionStatus = ConnectionStatus.disconnected;

    if (kDebugMode) {
      print("mqtt attempt");
    }

    _mqttClient = MqttServerClient.withPort(
        mqttHost, 'flutter_client/$deviceId', mqttPort);
    _mqttClient.secure = true;
    _mqttClient.securityContext = SecurityContext.defaultContext;
    _mqttClient.keepAlivePeriod = 20;
    _mqttClient.onConnected = onConnected;
    _mqttClient.onDisconnected = onDisconnected;
    _mqttClient.onSubscribed = onSubscribed;
    _mqttClient.onUnsubscribed = onUnsubscribed;
    _mqttClient.onSubscribed = onSubscribed;
    _mqttClient.onSubscribeFail = onSubscribeFail;
    _mqttClient.pongCallback = pong;

    _mqttClient.keepAlivePeriod = 60;

    final connMessage = MqttConnectMessage()
        .authenticateAs(mqttUsername, mqttPassword)
        .withWillTopic(_devicesClient)
        .withWillMessage('$deviceId disconnected unexpected')
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

        // TODO HEATING UNIT DATA,
        if (topic == "cbes/dekut/heating_unit") {
          final data = message.split(',');
          final tank1Value = (data[0].split(':'))[1];
          final tank2Value = (data[1].split(':'))[1];
          final tank3Value = (data[2].split(':'))[1];
          final flow1Value = (data[3].split(':'))[1];
          final flow2Value = (data[4].split(':'))[1];
          _heatingUnitData = {
            "tank1": tank1Value,
            "tank2": tank2Value,
            "tank3": tank3Value,
            "flow1": flow1Value,
            "flow2": flow2Value.substring(0, flow2Value.length - 1),
          };
          print(_heatingUnitData);
        }

        if (topic == "cbes/dekut/devices/#") {}
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
      publishMsg(_devicesClient, '$deviceId connected');
      print('Connected');
    }
  }

  void onDisconnected() {
    if (kDebugMode) {
      print('Disconnected');
      // TODO ON DISCONNECTED, FORCE THE USER OFFLINE
    }
  }

  void onSubscribed(String topic) {
    if (kDebugMode) {
      print('Subscribed topic: $topic');
    }
  }

  void onSubscribeFail(String topic) {
    if (kDebugMode) {
      print('Failed to subscribe $topic');
    }
  }

  void onUnsubscribed(String? topic) {
    if (kDebugMode) {
      print('Unsubscribed topic: $topic');
    }
  }

  void pong() {
    if (kDebugMode) {
      print('Ping response client callback invoked');
    }
  }
}
