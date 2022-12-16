import 'dart:ui';

import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  static const sigma=0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('Images/site1.jpg'), fit: BoxFit.cover)),
        child: ClipRRect(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            child: Text(
                    "OFFLINE",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: MediaQuery.of(context).size.width * 0.035,
                  fontSize:  MediaQuery.of(context).size.width * 0.075,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Center(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,),
          //     child: Text(
          //       "OFFLINE",
          //       style: TextStyle(
          //           color: Colors.white,
          //           letterSpacing: MediaQuery.of(context).size.width * 0.025,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 100.0),
          //     ),
          //   ),
          // ),
        )));
  }
}
