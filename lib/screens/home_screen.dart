import 'package:flutter/material.dart';

import '../widgets/windows_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: WindowsWrapper(
      child: Center(
        child: Text('HOME'),
      ),
    ));
  }
}
