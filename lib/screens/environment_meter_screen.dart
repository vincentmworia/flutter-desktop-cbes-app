import 'dart:ui';

import 'package:flutter/material.dart';

class UbibotScreen extends StatelessWidget {
  const UbibotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double sigma = 0; // from 0-10
    double opacity = 0.7;
    return Center(
      child: Container(
        width: 600,
        height: 400,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/site1.jpg'),
          fit: BoxFit.cover,
        )),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            color: Colors.white.withOpacity(opacity),
          ),
        ),
      ),
    );
  }
}
