import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../widgets/radial_gauge_sf.dart';
import '../widgets/linear_gauge.dart';
import '../widgets/search_view.dart';
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

  static const temperatureTitle = 'Temperature';

  // static const flowTitle = 'Flow Rate';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Consumer<MqttProvider>(builder: (context, mqttProv, child) {
        final List<Map<String, String>> heatingUnitData = [
          {'title': 'Tank 1', 'data': mqttProv.heatingUnitData?.tank1 ?? '0.0'},
          {'title': 'Tank 2', 'data': mqttProv.heatingUnitData?.tank2 ?? '0.0'},
          {'title': 'Tank 3', 'data': mqttProv.heatingUnitData?.tank3 ?? '0.0'},
        ];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: cons.maxHeight * 0.05,
                horizontal: cons.maxWidth * 0.005,
              ),
              width: cons.maxWidth * 0.4,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: cons.maxHeight * 0.5,
                    // todo Break the child into a widget
                    child: Row(
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
                            .toList()),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                          icon: const Icon(Icons.file_copy),
                          onPressed: () {},
                          label: const Text('Generate Excel')),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.picture_as_pdf),
                          onPressed: () {},
                          label: const Text('Generate PDF')),

                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                const EdgeInsets.only(top: 12, right: 6),
                                child: Text(
                                  'From:\t',
                                  style:
                                  Theme.of(context).textTheme.titleMedium,
                                )),
                            SizedBox(
                                width: 165,
                                height: 100,
                                child: DateTimeField(
                                  format: DateFormat("yyyy-MM-dd HH:mm"),
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                        currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.combine(date, time);
                                    } else {
                                      return currentValue;
                                    }
                                  },
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                const EdgeInsets.only(top: 12, right: 6),
                                child: Text(
                                  'To:\t',
                                  style:
                                  Theme.of(context).textTheme.titleMedium,
                                )),
                            SizedBox(
                                width: 165,
                                height: 100,
                                child: DateTimeField(
                                  format: DateFormat("yyyy-MM-dd HH:mm"),
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                        currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );
                                      return DateTimeField.combine(date, time);
                                    } else {
                                      return currentValue;
                                    }
                                  },
                                ))
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text('Search')),
                        Switch.adaptive(value: true, onChanged: (val) {}),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TankGraph(
                      axisTitle: "Temp (°C)",
                      spline1DataSource: mqttProv.temp1GraphData,
                      spline1Title: "Tank 1",
                      spline2DataSource: mqttProv.temp2GraphData,
                      spline2Title: "Tank 2",
                      spline3DataSource: mqttProv.temp3GraphData,
                      spline3Title: "Tank 3",
                    ),
                  ),
                ],
              ),
            ),
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 18.0),
            //       child: SizedBox(
            //         width: double.infinity,
            //         child: Center(
            //           child: Text(temperatureTitle,
            //             style: TextStyle(
            //                 color: Theme.of(context).colorScheme.primary,
            //                 letterSpacing: 3.0,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 20),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(
            //       width: double.infinity,
            //       height: height * 0.25,
            //       child: valueParams,
            //     ),
            //     Expanded(
            //       child: SizedBox(
            //         width: double.infinity,
            //         child: graphParams,
            //       ),
            //     ),
            //   ],
            // ),
            // todo feed in to the main parameter
            // _parameterView(
            //     context: context,
            //     width: cons.maxWidth,
            //     height: cons.maxHeight,
            //     title: temperatureTitle,
            //     valueParams: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: heatingUnitData
            //             .map((e) => Card(
            //                   elevation: 8,
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10)),
            //                   color: Colors.white.withOpacity(0.85),
            //                   shadowColor:
            //                       Theme.of(context).colorScheme.primary,
            //                   child: LinearGauge(
            //                       title: e['title'],
            //                       data: e['data'],
            //                       gaugeWidth: cons.maxWidth * 0.075),
            //                 ))
            //             .toList()),
            //     // todo Add the resolution to the title
            //     graphParams: TankGraph(
            //       axisTitle: "Temp (°C)",
            //       spline1DataSource: mqttProv.temp1GraphData,
            //       spline1Title: "Tank 1",
            //       spline2DataSource: mqttProv.temp2GraphData,
            //       spline2Title: "Tank 2",
            //       spline3DataSource: mqttProv.temp3GraphData,
            //       spline3Title: "Tank 3",
            //     )),
            // const VerticalDivider(),
            // _parameterView(
            //     context: context,
            //     width: cons.maxWidth,
            //     height: cons.maxHeight,
            //     title: flowTitle,
            //     valueParams: Consumer<MqttProvider>(
            //       builder: (context, mqttProv, child) {
            //         final List<Map<String, String>> heatingUnitData = [
            //           {
            //             'title': 'Flow S.H',
            //             'data': mqttProv.heatingUnitData?.flow2 ?? '0.0'
            //           },
            //           {
            //             'title': 'Flow H.E',
            //             'data': mqttProv.heatingUnitData?.flow1 ?? '0.0'
            //           },
            //         ];
            //
            //         return Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: heatingUnitData
            //                 .map((e) => Card(
            //                       elevation: 8,
            //                       shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(10)),
            //                       color: Colors.white.withOpacity(0.85),
            //                       shadowColor:
            //                           Theme.of(context).colorScheme.primary,
            //                       child: SizedBox(
            //                         width: 175,
            //                         height: double.infinity,
            //                         child: SyncfusionRadialGauge(
            //                           title: e['title']!,
            //                           data: e['data']!,
            //                           minValue: 0.0,
            //                           maxValue: 30.0,
            //                           range1Value: 10.0,
            //                           range2Value: 20.0,
            //                           units: 'lpm',
            //                         ),
            //                       ),
            //                     ))
            //                 .toList());
            //       },
            //     ),
            //     graphParams: TankGraph(
            //       axisTitle: "Flow (lpm)",
            //       spline1Title: "Flow (To Solar Heater)",
            //       spline1DataSource: mqttProv.flow2GraphData,
            //       spline2Title: "Flow (To Heat Exchanger)",
            //       spline2DataSource: mqttProv.flow1GraphData,
            //     )),
            // graphParams:const TankGraph()),
          ],
        );
      });
    });
  }
}
