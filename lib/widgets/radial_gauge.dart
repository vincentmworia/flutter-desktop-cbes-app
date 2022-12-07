import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class MyRadialGauge extends StatefulWidget {
  const MyRadialGauge(
      {Key? key,
      required this.title,
      required this.data,
      required this.gaugeHeight})
      : super(key: key);
  final String title;
  final double gaugeHeight;
  final String data;

  @override
  State<MyRadialGauge> createState() => _MyRadialGaugeState();
}

class _MyRadialGaugeState extends State<MyRadialGauge> {
  var opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<KdGaugeViewState> key = GlobalKey<KdGaugeViewState>();
    final value = double.parse(widget.data);
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (mounted) {
        setState(() => opacity = 1);
      }
    });
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(seconds: 1),
      child: SizedBox(
        height: widget.gaugeHeight,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.title.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: KdGaugeView(
                key: key,
                minSpeed: 0,
                maxSpeed: 50,
                speed: value,
                // animate: true,
                duration: const Duration(seconds: 1),
                unitOfMeasurement: 'lpm',
                unitOfMeasurementTextStyle: const TextStyle(fontSize: 10),
                speedTextStyle: const TextStyle(fontSize: 15),
                gaugeWidth: 5,
                minMaxTextStyle: const TextStyle(fontSize: 0),
                innerCirclePadding: 10,
                // inactiveGaugeColor: Colors.red,
                subDivisionCircleColors: Colors.white12,
                divisionCircleColors: Colors.white12,
                // activeGaugeColor: Colors.black,
                // baseGaugeColor: Colors.white,
                fractionDigits: 1,

                alertColorArray: const [Colors.blue, Colors.orange, Colors.red],
                alertSpeedArray: const [0, 15, 30],
              ),
            ),
          ],
        ),
        // child: MyRadialGauge(title: 'Flow 1', data: '30'),
      ),
    );
  }
}
