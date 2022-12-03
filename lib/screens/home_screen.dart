import 'package:flutter/material.dart';

import '../models/heating_unit.dart';
import '../widgets/windows_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    var heatingUnitData = HeatingUnit(
        tank1: '23.0',
        tank2: '22.5',
        tank3: '26.3',
        flow1: '11.6',
        flow2: '4.2');
    return SafeArea(
        child: WindowsWrapper(
      child: Center(
        child: Text(heatingUnitData.toMap().toString()),
        // child: Consumer<MqttProvider>(
        //   builder: (context, value, child) =>
        //       Text(value.heatingUnitData.toMap().toString()),
        // ),
      ),
    ));
  }
}
