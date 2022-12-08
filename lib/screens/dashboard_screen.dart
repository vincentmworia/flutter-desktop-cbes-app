import 'package:cbesdesktop/screens/home_screen.dart';
import 'package:cbesdesktop/widgets/dashboard_screen_heating_unit_consumer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/mqtt.dart';
import '../widgets/linear_gauge.dart';
import '../widgets/radial_gauge_kd.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key, required this.switchDashboardPage})
      : super(key: key);
  final Function switchDashboardPage;

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
                child: DashboardScreenHeatingUnitConsumer(
                  width: cons.maxWidth,
                  height: cons.maxHeight,
                ),
              ),
            ],
          );
      Widget cardView(String title, Widget? child) => title == 'TODO'
          ? SizedBox(
              width: cons.maxWidth * 0.4,
              height: cons.maxHeight * 0.4,
            )
          : GestureDetector(
              onDoubleTap: () => switchDashboardPage(PageTitle.heatingUnit,
                  HomeScreen.pageTitle(PageTitle.heatingUnit)),
              child: Card(
                elevation: 8,
                shadowColor: Theme.of(context).colorScheme.primary,

                // color: Color(0xff668366),
                // color: Color(0xff668366),
                // color: Colors.green,
                // color: Colors.grey,
                // color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                // color:Theme.of(context).colorScheme.secondary,
                color: Colors.white.withOpacity(0.65),
                // color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
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
