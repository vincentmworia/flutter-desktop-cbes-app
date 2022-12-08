import 'dart:async';

import 'package:cbesdesktop/providers/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../models/graph_axis.dart';

class TankGraph extends StatelessWidget {
  const TankGraph({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<MqttProvider>(
        builder: (_, mqttProv, ___) => SfCartesianChart(
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          // annotations:const [CartesianChartAnnotation( )],
          // Chart title
          title: ChartTitle(text: 'Temperatures'),
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
              name: "Temp 1",
              xAxisName: "Time (min)",
              yAxisName: "Temp (°C)",
              dataSource: mqttProv.temp1GraphData,
              color: Colors.red,
              xValueMapper: (GraphAxis sales, _) => sales.x,
              yValueMapper: (GraphAxis sales, _) => sales.y,
              // dataLabelSettings: const DataLabelSettings(
              //   isVisible: true,
              //   labelPosition: ChartDataLabelPosition.outside,
              // ),
            ),
            SplineSeries<GraphAxis, String>(
              name: "Temp 2",
              xAxisName: "Time (min)",
              yAxisName: "Temp (°C)",
              dataSource: mqttProv.temp2GraphData,
              color: Colors.blue,
              xValueMapper: (GraphAxis sales, _) => sales.x,
              yValueMapper: (GraphAxis sales, _) => sales.y,
            ),
            SplineSeries<GraphAxis, String>(
              name: "Temp 3",
              xAxisName: "Time (min)",
              yAxisName: "Temp (°C)",
              dataSource: mqttProv.temp3GraphData,
              color: Colors.orange,
              xValueMapper: (GraphAxis sales, _) => sales.x,
              yValueMapper: (GraphAxis sales, _) => sales.y,
            ),
          ],
        ),
      ),
    );
  }
}
