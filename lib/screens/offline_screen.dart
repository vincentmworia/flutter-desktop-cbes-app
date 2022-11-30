import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      child: Center(
        child: Text(
          "OFFLINE",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: MediaQuery.of(context).size.width * 0.025,
              fontWeight: FontWeight.bold,
              fontSize: 50.0),
        ),
      ),
    );
  }
}
