import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../helpers/global_data.dart';
import './radial_gauge_kd.dart';

class SyncfusionRadialGauge extends StatelessWidget {
  const SyncfusionRadialGauge(
      {Key? key, required this.title, required this.data})
      : super(key: key);
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    final value = double.parse(data);
    final color = value < 20
        ? lowColor
        : value > 20 && value < 50
            ? mediumColor
            : highColor;
    return SfRadialGauge(
      title: GaugeTitle(
        text: title,
        textStyle: const TextStyle(
            fontSize: 18, letterSpacing: 2.0, fontWeight: FontWeight.w600),
      ),
      animationDuration: 4000,
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
            minimum: KdRadialGauge.minValue,
            maximum: KdRadialGauge.maxValue,
            startAngle: 140,
            endAngle: 40,
            interval: 10,
            useRangeColorForAxis: true,
            axisLabelStyle:
                GaugeTextStyle(color: Theme.of(context).colorScheme.primary),
            labelOffset: 10,
            majorTickStyle:
                MajorTickStyle(color: Theme.of(context).colorScheme.primary),
            minorTicksPerInterval: 5.0,
            minorTickStyle: MinorTickStyle(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
            pointers: <GaugePointer>[
              MarkerPointer(
                value: value,
                color: color,
              ),
              RangePointer(
                color: color,
                value: value,
              ),
              NeedlePointer(
                  value: value,
                  needleStartWidth: 1,
                  needleEndWidth: 3,
                  needleColor: color),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      '$data\tlpm',
                      // child: Text('$data °C',
                      style: TextStyle(
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                  ),
                  angle: 90,
                  positionFactor: 0.8)
            ]),
      ],
    );
  }
}
