import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/mqtt.dart';
import '../widgets/linear_gauge.dart';
import '../widgets/radial_gauge.dart';

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
                        title: 'Tank 1',
                        data: mqttProv.heatingUnitData?.tank1  ,
                        gaugeWidth: cons.maxWidth * 0.075),
                    LinearGauge(
                        title: 'Tank 2',
                        data: mqttProv.heatingUnitData?.tank2 ,
                        gaugeWidth: cons.maxWidth * 0.075),
                    LinearGauge(
                        title: 'Tank 3',
                        data: mqttProv.heatingUnitData?.tank3  ,
                        gaugeWidth: cons.maxWidth * 0.075),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyRadialGauge(
                            title: 'Tank 1',
                            data: mqttProv.heatingUnitData?.flow1,
                            gaugeHeight: cons.maxHeight * 0.15),
                        MyRadialGauge(
                            title: 'Tank 2',
                            data: mqttProv.heatingUnitData?.flow2 ,
                            gaugeHeight: cons.maxHeight * 0.15),
                      ],
                    ))
                  ],
                ),
              )),
            ],
          );
      Widget cardView(String title, Widget? child) => title == 'TODO'
          ? SizedBox(
              width: cons.maxWidth * 0.4,
              height: cons.maxHeight * 0.4,
            )
          : Card(
              elevation: 10,
              // color: Color(0xff668366),
              // color: Color(0xff668366),
              // color: Colors.green,
              // color: Colors.grey,
              // color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              // color:Theme.of(context).colorScheme.secondary,
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
                          title,
                          style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
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
                  cardView('SOLAR HEATING UNIT', heatingUnitCardData()),
                  cardView('ENVIRONMENT METER', null),
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
