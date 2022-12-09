import 'dart:async';

import 'package:cbesdesktop/providers/mqtt.dart';
import 'package:cbesdesktop/screens/heating_unit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../models/graph_axis.dart';

class TankGraph extends StatelessWidget {
  const TankGraph({Key? key, required this.title}) : super(key: key);
  final String title;

  static const graph1Color = Colors.red;
  static const graph2Color = Colors.blue;
  static const graph3Color = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<MqttProvider>(
        builder: (_, mqttProv, ___) =>
            SfCartesianChart(
                enableAxisAnimation: true,
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: "Time (min)")),
                plotAreaBackgroundImage: const AssetImage('images/site1.PNG') ,

                primaryYAxis: NumericAxis(
                title: AxisTitle(
                text: title == HeatingUnitScreen.temperatureTitle
            ? "Temp (°C)"
                : "Flow (lpm)"),
      ),
      // annotations:const [CartesianChartAnnotation( )],
      // Chart title
      // title: ChartTitle(text: title),
      // Enable legend
      legend: Legend(
        isVisible: true,
      ),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      // plotAreaBackgroundImage: const AssetImage('images/home2.jpg'),
      // todo Fade Image
      series: <ChartSeries>[
        /*
                    AreaSeries
                    LineSeries
                    ColumnSeries
                    BubbleSeries
                    SplineSeries
                    SplineAreaSeries
                    StepAreaSeries
                    */
        SplineSeries<GraphAxis, String>(
          name: title == HeatingUnitScreen.temperatureTitle
              ? "Temp 1"
              : "Flow 1",
          xAxisName: "Time (min)",
          yAxisName: title == HeatingUnitScreen.temperatureTitle
              ? "Temp (°C)"
              : "Flow (lpm)",
          dataSource: title == HeatingUnitScreen.temperatureTitle
              ? mqttProv.temp1GraphData
              : mqttProv.flow1GraphData,
          color: graph1Color,
          xValueMapper: (GraphAxis data, _) => data.x,
          yValueMapper: (GraphAxis data, _) => data.y,
          // dataLabelSettings: const DataLabelSettings(
          //   isVisible: true,
          //   labelPosition: ChartDataLabelPosition.outside,
          // ),
        ),
        SplineSeries<GraphAxis, String>(
          name: title == HeatingUnitScreen.temperatureTitle
              ? "Temp 2"
              : "Flow 2",
          xAxisName: "Time (min)",
          yAxisName: title == HeatingUnitScreen.temperatureTitle
              ? "Temp (°C)"
              : "Flow (lpm)",
          dataSource: title == HeatingUnitScreen.temperatureTitle
              ? mqttProv.temp2GraphData
              : mqttProv.flow2GraphData,
          color: graph2Color,
          xValueMapper: (GraphAxis data, _) => data.x,
          yValueMapper: (GraphAxis data, _) => data.y,
        ),
        if (title == HeatingUnitScreen.temperatureTitle)
          SplineSeries<GraphAxis, String>(
            name: "Temp 3",
            xAxisName: "Time (min)",
            yAxisName: "Temp (°C)",
            dataSource: mqttProv.temp3GraphData,
            color: graph3Color,
            xValueMapper: (GraphAxis data, _) => data.x,
            yValueMapper: (GraphAxis data, _) => data.y,
          ),
      ],
    ),)
    ,
    );
  }
}
