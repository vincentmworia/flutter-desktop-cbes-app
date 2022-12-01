import 'package:cbesdesktop/providers/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/windows_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WindowsWrapper(
      child: Center(
        child: Consumer<MqttProvider>(
          builder: (context, value, child) =>
              Text(value.heatingUnitData.toMap().toString()),
        ),
      ),
    ));
  }
}
