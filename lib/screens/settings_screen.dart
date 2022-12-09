import 'package:flutter/material.dart';

import '../providers/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(fixedSize: const Size(175, 100)),
        onPressed: () {
          FirebaseAuthentication.logout(context);
        },
        child: const Text('Logout'),
      ),
    );
  }
}
