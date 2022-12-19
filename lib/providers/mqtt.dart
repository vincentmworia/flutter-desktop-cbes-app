import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/environment_meter.dart';
import '../models/graph_axis.dart';
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
  Timer? timer;

  MqttServerClient get mqttClient => _mqttClient;

  String? get disconnectTopic => _devicesClient;

  String get disconnectMessage => "Disconnected-$_loginTime";

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

  final List<GraphAxis> temperatureGraphData = [];
  final List<GraphAxis> humidityGraphData = [];
  final List<GraphAxis> illuminanceGraphData = [];

  final List<GraphAxis> gridVoltageGraphData = [];
  final List<GraphAxis> pvVoltageGraphData = [];
  final List<GraphAxis> outputVoltageGraphData = [];

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

  //
  // static final String deviceId =
  //     '&${ LoginUserData.getLoggedUser!.email}&${ LoginUserData.getLoggedUser!.firstname}&${ LoginUserData.getLoggedUser!.lastname}';

  // static final String _devicesClient = 'cbes/dekut/devices/$platform/${json.encode(LoginUserData.getLoggedUser?.asMqttMap())}';

  String? _deviceId;
  String? _devicesClient;
  DateTime? _loginTime;

  // todo If disconnected, nullify the token and forcefully logout the user

  String _duration(DateTime time) =>
      DateFormat('HH:mm:ss').format(/*time.subtract(Duration(minutes: delay))*/
          time);

  Future<ConnectionStatus> initializeMqttClient() async {
    _deviceId =
        '&${LoginUserData.getLoggedUser!.email}&${LoginUserData.getLoggedUser!.firstname}&${LoginUserData.getLoggedUser!.lastname}';
    _devicesClient = 'cbes/dekut/devices/$platform/$_deviceId';

    _mqttClient = MqttServerClient.withPort(
        mqttHost, 'flutter_client/$_deviceId', mqttPort);
    _mqttClient.secure = true;
    _mqttClient.securityContext = SecurityContext.defaultContext;
    _mqttClient.keepAlivePeriod = 20;
    _mqttClient.onConnected = onConnected;
    _mqttClient.onDisconnected = onDisconnected;
    // _mqttClient.onSubscribed = onSubscribed;
    // _mqttClient.onUnsubscribed = onUnsubscribed;
    // _mqttClient.onSubscribeFail = onSubscribeFail;
    // _mqttClient.pongCallback = pong;
    _mqttClient.keepAlivePeriod = 60;

    final connMessage = MqttConnectMessage()
        .authenticateAs(mqttUsername, mqttPassword)
        .withWillTopic(_devicesClient!)
        .withWillMessage('DisconnectedHard-$_loginTime')
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
      void removeFirstElement(List list) {
        if (list.length >= 370) {
          list.removeAt(0);
        }
      }

      // todo change the duration dynamically on request from the client
      timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (_heatingUnitData != null) {
          removeFirstElement(temp1GraphData);
          removeFirstElement(temp2GraphData);
          removeFirstElement(temp3GraphData);
          removeFirstElement(flow1GraphData);
          removeFirstElement(flow2GraphData);
          removeFirstElement(temperatureGraphData);
          removeFirstElement(humidityGraphData);
          removeFirstElement(illuminanceGraphData);
          removeFirstElement(gridVoltageGraphData);
          removeFirstElement(pvVoltageGraphData);
          removeFirstElement(outputVoltageGraphData);

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
          temperatureGraphData.add(GraphAxis(_duration(time),
              double.parse(_environmentMeterData!.temperature!)));
          humidityGraphData.add(GraphAxis(
              _duration(time), double.parse(_environmentMeterData!.humidity!)));
          illuminanceGraphData.add(GraphAxis(_duration(time),
              double.parse(_environmentMeterData!.illuminance!)));
          gridVoltageGraphData.add(GraphAxis(
              _duration(time), double.parse(_powerUnitData!.acVoltage!)));
          pvVoltageGraphData.add(GraphAxis(
              _duration(time), double.parse(_powerUnitData!.pvInputVoltage!)));
          outputVoltageGraphData.add(GraphAxis(
              _duration(time), double.parse(_powerUnitData!.outputVoltage!)));
        }
        notifyListeners();
      });
      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        var message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        if (topic == "cbes/dekut/data/heating_unit") {
          _heatingUnitData =
              HeatingUnit.fromMap(json.decode(message) as Map<String, dynamic>);
          notifyListeners();
        }

        if (topic == "cbes/dekut/data/environment_meter") {
          _environmentMeterData = EnvironmentMeter.fromMap(
              json.decode(message) as Map<String, dynamic>);
          notifyListeners();
        }
        if (topic == "cbes/dekut/data/power_unit") {
          _powerUnitData =
              PowerUnit.fromMap(json.decode(message) as Map<String, dynamic>);
          notifyListeners();
        }
        if (topic.contains("cbes/dekut/devices/")) {
          final deviceData = topic.split('/');
          if (kDebugMode) {
            print('''${deviceData[3]} - ${deviceData[4]}
          State: $message''');
          }
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
    _connStatus = ConnectionStatus.connected;
    _loginTime = DateTime.now();
    publishMsg(_devicesClient!, 'Connected-$_loginTime');
  }

  void onDisconnected() {
    _connStatus = ConnectionStatus.disconnected;
    timer?.cancel();
    notifyListeners();
    // TODO ON DISCONNECTED, FORCE THE USER OFFLINE
    // Use firebase Auth to force the application to HomePage
  }
}
