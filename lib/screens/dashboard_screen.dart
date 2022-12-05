import 'package:cbesdesktop/providers/mqtt.dart';
import 'package:cbesdesktop/widgets/linear_gauge.dart';
import 'package:cbesdesktop/widgets/radial_gauge.dart';
import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const Center(
    //   child: Text("Dashboard Screen"),
    // );
    return LayoutBuilder(builder: (builder, cons) {
      final bdRadius = BorderRadius.circular(10);

      Widget heatingUnitCardData() => Column(
            children: <Widget>[
              Expanded(
                  child: Consumer<MqttProvider>(
                builder: (context, mqttProv, child) => Row(
                  children: [
                    LinearGauge(
                        title: 'Temp 1',
                        data: mqttProv.heatingUnitData.tank1,
                        gaugeWidth: cons.maxWidth * 0.075),
                    LinearGauge(
                        title: 'Temp 2',
                        data: mqttProv.heatingUnitData.tank2,
                        gaugeWidth: cons.maxWidth * 0.075),
                    LinearGauge(
                        title: 'Temp 3',
                        data: mqttProv.heatingUnitData.tank3,
                        gaugeWidth: cons.maxWidth * 0.075),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyRadialGauge(
                            title: 'Flow 1',
                            data: mqttProv.heatingUnitData.flow1,
                            gaugeHeight: cons.maxHeight * 0.15),
                        MyRadialGauge(
                            title: 'Flow 2',
                            data: mqttProv.heatingUnitData.flow2,
                            gaugeHeight: cons.maxHeight * 0.15),
                      ],
                    ))
                  ],
                ),
              )),
            ],
          );
      Widget cardView(String? title, Widget? child) => Card(
            elevation: 10,
            // color: Color(0xff2E8B57),
            // color: Colors.green,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            shape: RoundedRectangleBorder(borderRadius: bdRadius),
            child: SizedBox(
              width: cons.maxWidth * 0.4,
              height: cons.maxHeight * 0.4,
              child: Column(
                children: [
                  Container(
                    width: cons.maxWidth * 0.2,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: bdRadius),
                    child: Center(
                      child: Text(
                        title ?? 'TODO',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  Expanded(child: child ?? Container()),
                ],
              ),
            ),
          );
      return SizedBox(
        width: cons.maxWidth,
        height: cons.maxHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardView('HEATING UNIT', heatingUnitCardData()),
                  cardView('UBIBOT', null),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  cardView('POWER UNIT', null),
                  cardView('TODO', null),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
