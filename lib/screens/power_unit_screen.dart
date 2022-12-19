import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/radial_gauge_sf.dart';
import '../widgets/linear_gauge.dart';
import '../widgets/tank_graph.dart';
import '../providers/mqtt.dart';

class PowerUnitScreen extends StatelessWidget {
  const PowerUnitScreen({Key? key}) : super(key: key);

  static const _pageRatio = 0.25;

  static const temperatureAndHumidityTitle = 'Temperature and Humidity';
  static const illuminanceTitle = 'Illuminance';

  static final bdRadius = BorderRadius.circular(10);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Consumer<MqttProvider>(
        builder: (context, mqttProv, child) {
          final List<Map<String, dynamic>> environmentMeterData1 = [
            {
              'title': 'Grid Voltage',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Humidity',
              'units': '%',
              'data': mqttProv.environmentMeterData?.humidity ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Illuminance',
              'units': 'lux',
              'data': mqttProv.environmentMeterData?.illuminance ?? '0.0',
              'minValue': 0.0,
              'maxValue': 500.0,
              'range1Value': 100.0,
              'range2Value': 250.0,
            },
          ];
          final List<Map<String, dynamic>> environmentMeterData2 = [
            {
              'title': 'Grid Voltage',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Humidity',
              'units': '%',
              'data': mqttProv.environmentMeterData?.humidity ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Illuminance',
              'units': 'lux',
              'data': mqttProv.environmentMeterData?.illuminance ?? '0.0',
              'minValue': 0.0,
              'maxValue': 500.0,
              'range1Value': 100.0,
              'range2Value': 250.0,
            },
          ];
          final List<Map<String, dynamic>> environmentMeterData3 = [
            {
              'title': 'Grid Voltage',
              'units': '°C',
              'data': mqttProv.environmentMeterData?.temperature ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Humidity',
              'units': '%',
              'data': mqttProv.environmentMeterData?.humidity ?? '0.0',
              'minValue': 0.0,
              'maxValue': 100.0,
              'range1Value': 25.0,
              'range2Value': 55.0,
            },
            {
              'title': 'Illuminance',
              'units': 'lux',
              'data': mqttProv.environmentMeterData?.illuminance ?? '0.0',
              'minValue': 0.0,
              'maxValue': 500.0,
              'range1Value': 100.0,
              'range2Value': 250.0,
            },
          ];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: environmentMeterData1
                        .map((e) => Card(
                              elevation: 8,
                              shadowColor: Theme.of(context).colorScheme.primary,
                              color: Colors.white.withOpacity(0.65),
                              shape:
                                  RoundedRectangleBorder(borderRadius: bdRadius),
                              child: SizedBox(
                                width: cons.maxWidth * _pageRatio * 0.7,
                                height: cons.maxHeight * _pageRatio,
                                child: SyncfusionRadialGauge(
                                  title: e['title'],
                                  units: e['units'],
                                  data: e['data'],
                                  minValue: e['minValue'],
                                  maxValue: e['maxValue'],
                                  range1Value: e['range1Value'],
                                  range2Value: e['range2Value'],
                                ),
                              ),
                            ))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: environmentMeterData2
                        .map((e) => Card(
                              elevation: 8,
                              shadowColor: Theme.of(context).colorScheme.primary,
                              color: Colors.white.withOpacity(0.65),
                              shape:
                                  RoundedRectangleBorder(borderRadius: bdRadius),
                              child: SizedBox(
                                width: cons.maxWidth * _pageRatio * 0.7,
                                height: cons.maxHeight * _pageRatio,
                                child: SyncfusionRadialGauge(
                                  title: e['title'],
                                  units: e['units'],
                                  data: e['data'],
                                  minValue: e['minValue'],
                                  maxValue: e['maxValue'],
                                  range1Value: e['range1Value'],
                                  range2Value: e['range2Value'],
                                ),
                              ),
                            ))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: environmentMeterData3
                        .map((e) => Card(
                              elevation: 8,
                              shadowColor: Theme.of(context).colorScheme.primary,
                              color: Colors.white.withOpacity(0.65),
                              shape:
                                  RoundedRectangleBorder(borderRadius: bdRadius),
                              child: SizedBox(
                                width: cons.maxWidth * _pageRatio * 0.7,
                                height: cons.maxHeight * _pageRatio,
                                child: SyncfusionRadialGauge(
                                  title: e['title'],
                                  units: e['units'],
                                  data: e['data'],
                                  minValue: e['minValue'],
                                  maxValue: e['maxValue'],
                                  range1Value: e['range1Value'],
                                  range2Value: e['range2Value'],
                                ),
                              ),
                            ))
                        .toList()),
              ),

              Expanded(
                child: TankGraph(
                  axisTitle: "Illuminance (lux)",
                  spline1Title: "Illuminance",
                  spline1DataSource: mqttProv.illuminanceGraphData,
                  spline2Title: null,
                  spline2DataSource: null,
                  spline3Title: null,
                  spline3DataSource: null,
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
