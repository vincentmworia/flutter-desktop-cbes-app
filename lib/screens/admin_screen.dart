import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("""
      - Viewing online users in realtime
      - Monitoring all users and their logins
      - Allow Users to access application
      - Promoting users to administrators
      - Demoting users to normal users
      """),
    );
  }
}
