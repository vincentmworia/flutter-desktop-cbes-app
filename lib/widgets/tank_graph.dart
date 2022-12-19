import 'package:cbesdesktop/screens/environment_meter_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/mqtt.dart';
import '../screens/heating_unit_screen.dart';

import '../models/graph_axis.dart';

class TankGraph extends StatelessWidget {
  const TankGraph({
    Key? key,
    required this.axisTitle,
    this.spline1Title,
    this.spline1DataSource,
    this.spline2Title,
    this.spline2DataSource,
    this.spline3Title,
    this.spline3DataSource,
  }) : super(key: key);
  final String axisTitle;
  final String? spline1Title;
  final List<GraphAxis>? spline1DataSource;
  final String? spline2Title;
  final List<GraphAxis>? spline2DataSource;
  final String? spline3Title;
  final List<GraphAxis>? spline3DataSource;

  static const graph1Color = Colors.red;
  static const graph2Color = Colors.blue;
  static const graph3Color = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<MqttProvider>(
        builder: (_, mqttProv, ___) => SfCartesianChart(
          enableAxisAnimation: true,
          primaryXAxis: CategoryAxis(title: AxisTitle(text: "Time")),
          // todo
          plotAreaBackgroundImage:
              const AssetImage('images/graph_background.PNG'),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: axisTitle),
          ),
          // todo title?
          // title: ChartTitle(text: title),
          legend: Legend(
            isVisible: true,
          ),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
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
              name: spline1Title,
              xAxisName: "Time (min)",
              yAxisName: spline1Title,
              // todo Fetch appropriate data
              dataSource: spline1DataSource ?? [],
              color: graph1Color,

              xValueMapper: (GraphAxis data, _) => data.x,
              yValueMapper: (GraphAxis data, _) => data.y,
              dataLabelSettings: const DataLabelSettings(
                isVisible: false,
                labelPosition: ChartDataLabelPosition.inside,
              ),
            ),
            if (spline2Title != null)
              SplineSeries<GraphAxis, String>(
                name: spline2Title,
                xAxisName: "Time (min)",
                yAxisName: spline2Title,
                dataSource: spline2DataSource ?? [],
                color: graph2Color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
                xValueMapper: (GraphAxis data, _) => data.x,
                yValueMapper: (GraphAxis data, _) => data.y,
              ),
            if (spline3Title != null)
              SplineSeries<GraphAxis, String>(
                name: spline3Title,
                xAxisName: "Time (min)",
                yAxisName: spline3Title,
                dataSource: spline3DataSource ?? [],
                color: graph3Color,
                // todo???
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                  labelPosition: ChartDataLabelPosition.inside,
                ),
                xValueMapper: (GraphAxis data, _) => data.x,
                yValueMapper: (GraphAxis data, _) => data.y,
              ),
          ],
        ),
      ),
    );
  }
}
