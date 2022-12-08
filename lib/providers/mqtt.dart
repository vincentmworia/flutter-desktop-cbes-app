import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cbesdesktop/models/graph_axis.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/enviroment_meter.dart';
import '../models/heating_unit.dart';
import '../models/power_unit.dart';
import '../private_data.dart';
import './login_user_data.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

// todo subscribe to all mqtt channels
class MqttProvider with ChangeNotifier {
  late MqttServerClient _mqttClient;
  static bool forceOffline = true;
  Timer? timer;

  MqttServerClient get mqttClient => _mqttClient;

  String get disconnectTopic => _devicesClient;

  String get disconnectMessage => _devicesClientMessage;

  HeatingUnit? get heatingUnitData => _heatingUnitData;
  HeatingUnit? _heatingUnitData;

  EnvironmentMeter? get environmentMeterData => _environmentMeterData;
  EnvironmentMeter? _environmentMeterData;

  PowerUnit? get powerUnitData => _powerUnitData;
  PowerUnit? _powerUnitData;

  final List<GraphAxis> temp1GraphData = [];
  final List<GraphAxis> temp2GraphData = [];
  final List<GraphAxis> temp3GraphData = [];
  final List<GraphAxis> flow1GraphData = [];
  final List<GraphAxis> flow2GraphData = [];

  var _connStatus = ConnectionStatus.disconnected;

  ConnectionStatus get connectionStatus => _connStatus;

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

  String _duration(DateTime time) =>
      DateFormat('HH:mm').format(/*time.subtract(Duration(minutes: delay))*/
          time);

  Future<ConnectionStatus> initializeMqttClient() async {
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
    } catch (e) {
      if (kDebugMode) {
        print('\n\nException: $e');
      }
      _mqttClient.disconnect();
      _connStatus = ConnectionStatus.disconnected;
    }
    if (_connStatus == ConnectionStatus.connected) {
      _mqttClient.subscribe("cbes/dekut/#", MqttQos.exactlyOnce);

      // timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      //   if (_heatingUnitData != null) {
      //     final time = DateTime.now();
      //     temp1GraphData.add(GraphAxis(
      //         _duration(time), double.parse(_heatingUnitData!.tank1!)));
      //     temp2GraphData.add(GraphAxis(
      //         _duration(time), double.parse(_heatingUnitData!.tank1!)));
      //     temp3GraphData.add(GraphAxis(
      //         _duration(time), double.parse(_heatingUnitData!.tank1!)));
      //     flow1GraphData.add(GraphAxis(
      //         _duration(time), double.parse(_heatingUnitData!.tank1!)));
      //     flow2GraphData.add(GraphAxis(
      //         _duration(time), double.parse(_heatingUnitData!.tank1!)));
      //     notifyListeners();
      //   }
      //   // print(heatingUnitGraphData);
      // });
      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        var message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        if (topic == "cbes/dekut/data/heating_unit") {
          _heatingUnitData =
              HeatingUnit.fromMap(json.decode(message) as Map<String, dynamic>);
          if (_heatingUnitData != null) {
            final time = DateTime.now();
            temp1GraphData.add(GraphAxis(
                _duration(time), double.parse(_heatingUnitData!.tank1!)));
            temp2GraphData.add(GraphAxis(
                _duration(time), double.parse(_heatingUnitData!.tank2!)));
            temp3GraphData.add(GraphAxis(
                _duration(time), double.parse(_heatingUnitData!.tank3!)));
            flow1GraphData.add(GraphAxis(
                _duration(time), double.parse(_heatingUnitData!.flow1!)));
            flow2GraphData.add(GraphAxis(
                _duration(time), double.parse(_heatingUnitData!.flow2!)));
          }
          notifyListeners();
        }

        if (topic == "cbes/dekut/data/environment_meter") {
          _environmentMeterData = EnvironmentMeter.fromMap(
              json.decode(message) as Map<String, dynamic>);
          print(_environmentMeterData?.asMap());
          notifyListeners();
        }
        if (topic == "cbes/dekut/data/power_unit") {
          _powerUnitData =
              PowerUnit.fromMap(json.decode(message) as Map<String, dynamic>);
          print(_powerUnitData?.asMap());
          notifyListeners();
        }
        if (topic.contains("cbes/dekut/devices/")) {
          final deviceData = topic.split('/');
          print('''${deviceData[3]} - ${deviceData[4]}
          State: $message''');
          // todo Get all the devices status and display in the UI,
          //  Disconnected or connected,
          // todo display online users like whatsapp
          // todo Record in firebase how long a user is logged in or logged out?
        }
      });
    }

    return _connStatus;
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
      _connStatus = ConnectionStatus.connected;
      publishMsg(_devicesClient, 'Connected');
    }
  }

  void onDisconnected() {
    _connStatus = ConnectionStatus.disconnected;
    if (kDebugMode) {
      print('Disconnected');
      forceOffline = true;
      timer?.cancel();
      notifyListeners();
      // TODO ON DISCONNECTED, FORCE THE USER OFFLINE
      // Use firebase Auth to force the application to HomePage
    }
  }
}
