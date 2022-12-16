import 'package:cbesdesktop/widgets/radial_gauge_kd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/mqtt.dart';
import './radial_gauge_sf.dart';

class DashboardScreenPowerUnitConsumer extends StatelessWidget {
  const DashboardScreenPowerUnitConsumer(
      {Key? key, required this.width, required this.height})
      : super(key: key);
  final double width;
  final double height;
  static const ratio = 0.25;

  @override
  Widget build(BuildContext context) => Consumer<MqttProvider>(
        builder: (context, mqttProv, child) {
          final List<Map<String, dynamic>> environmentData = [
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
          ];
          final List<Map<String, dynamic>> powerUnitData2 = [
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Temperature',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
          ];
          // todo RENDER THE TEXTS FROM MQTT
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: environmentData
                  .map(
                    (e) => Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 30,
                              height: height,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // todo
                                children: [
                                  // Expanded(
                                  //   child: KdRadialGauge(
                                  //       title: 'Power',
                                  //       data: mqttProv.heatingUnitData?.flow1,
                                  //       gaugeHeight: height * 0.15,units: 'lpm'),
                                  // ),
                                  // Expanded(
                                  //   child: KdRadialGauge(
                                  //       title: 'Tank 1',
                                  //       data: mqttProv.heatingUnitData?.flow1,
                                  //       gaugeHeight: height * 0.15,units: 'lpm'),
                                  // ),
                                ],
                              ),
                            ))),
                  )
                  .toList());
        },
      );
}
