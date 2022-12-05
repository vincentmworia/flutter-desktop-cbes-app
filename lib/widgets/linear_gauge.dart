import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LinearGauge extends StatelessWidget {
  const LinearGauge({
    Key? key,
    required this.title,
    required this.data,
    required this.gaugeWidth,
  }) : super(key: key);
  final String title;
  final String data;
  final double gaugeWidth;

  @override
  Widget build(BuildContext context) {
    final value = double.parse(data);
    final color = value < 20
        ? Colors.blue
        : value > 20 && value < 50
            ? Colors.orange
            : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SizedBox(
              width: gaugeWidth,
              child: SfLinearGauge(
                animationDuration: 1000,
                minimum: 0,
                maximum: 100,
                orientation: LinearGaugeOrientation.vertical,
                animateAxis: true,
                animateRange: true,
                showLabels: true,
                axisLabelStyle:
                    const TextStyle(color: Colors.white, fontSize: 10),
                axisTrackStyle: const LinearAxisTrackStyle(color: Colors.grey ),
                useRangeColorForAxis: true,
                labelPosition: LinearLabelPosition.inside,
                interval: 20,
                markerPointers: [
                  LinearWidgetPointer(
                    value: value,
                    child: Container(
                      width: 50,
                      height: 13,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                    ),
                  )
                ],
                barPointers: [
                  LinearBarPointer(
                    value: value,
                    color: color,
                  )
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.all(2),
            child: Text(
              '${value.toStringAsFixed(1)} °C',
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
