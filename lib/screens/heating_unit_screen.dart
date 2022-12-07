import 'package:flutter/material.dart';

class HeatingUnitScreen extends StatelessWidget {
  const HeatingUnitScreen({Key? key}) : super(key: key);

  static const _pageRatio = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: cons.maxWidth * _pageRatio,
            height: cons.maxHeight,
            color: Colors.blue,
          ),
          Container(
            width: cons.maxWidth * (1 - _pageRatio),
            height: cons.maxHeight,
            color: Colors.red,
          ),
        ],
      );
    });
  }
}
