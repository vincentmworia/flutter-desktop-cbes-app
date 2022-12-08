import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/radial_gauge_sf.dart';
import '../widgets/linear_gauge.dart';
import '../widgets/tank_graph.dart';
import '../providers/mqtt.dart';

class HeatingUnitScreen extends StatelessWidget {
  const HeatingUnitScreen({Key? key}) : super(key: key);

  static const _pageRatio = 0.49;

  Widget _parameterView({
    required BuildContext context,
    required double width,
    required double height,
    required String title,
    required Widget valueParams,
    required Widget graphParams,
  }) =>
      SizedBox(
        width: width * _pageRatio,
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: height * 0.25,
              child: valueParams,
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: graphParams,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _parameterView(
              context: context,
              width: cons.maxWidth,
              height: cons.maxHeight,
              title: 'TEMPERATURE',
              valueParams: Consumer<MqttProvider>(
                builder: (context, mqttProv, child) {
                  final List<Map<String, String>> heatingUnitData = [
                    {
                      'title': 'Tank 1',
                      'data': mqttProv.heatingUnitData?.tank1 ?? '0.0'
                    },
                    {
                      'title': 'Tank 2',
                      'data': mqttProv.heatingUnitData?.tank2 ?? '0.0'
                    },
                    {
                      'title': 'Tank 3',
                      'data': mqttProv.heatingUnitData?.tank3 ?? '0.0'
                    },
                  ];

                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: heatingUnitData
                          .map((e) => Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white.withOpacity(0.85),
                                shadowColor:
                                    Theme.of(context).colorScheme.primary,
                                child: LinearGauge(
                                    title: e['title'],
                                    data: e['data'],
                                    gaugeWidth: cons.maxWidth * 0.075),
                              ))
                          .toList());
                },
              ),
              // todo Add the resolution to the title
              graphParams:const TankGraph()),
          const VerticalDivider(),
          _parameterView(
              context: context,
              width: cons.maxWidth,
              height: cons.maxHeight,
              title: 'FLOW RATE',
              valueParams: Consumer<MqttProvider>(
                builder: (context, mqttProv, child) {
                  final List<Map<String, String>> heatingUnitData = [
                    {
                      'title': 'Flow 1',
                      'data': mqttProv.heatingUnitData?.flow1 ?? '0.0'
                    },
                    {
                      'title': 'Flow 2',
                      'data': mqttProv.heatingUnitData?.flow2 ?? '0.0'
                    },
                  ];

                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: heatingUnitData
                          .map((e) => Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.white.withOpacity(0.85),
                                shadowColor:
                                    Theme.of(context).colorScheme.primary,
                                child: SizedBox(
                                  width: 175,
                                  height: double.infinity,
                                  child: SyncfusionRadialGauge(
                                    title: e['title']!,
                                    data: e['data']!,
                                  ),
                                ),
                              ))
                          .toList());
                },
              ),
              graphParams:const TankGraph()),
        ],
      );
    });
  }
}
