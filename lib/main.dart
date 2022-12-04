import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
// export './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './providers/login_user_data.dart';
import './providers/mqtt.dart';

void main() async {
  runApp(const MyApp());
  // todo Lock orientation

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;

      win.minSize =const Size(1100, 600);
      win.alignment = Alignment.center;
      win.title = MyApp.appTitle;
      win.maximize();
      win.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'CBES DASHBOARD';
  static const appPrimaryColor = Color(0xff0b6623);

  // static const appPrimaryColor = Color(0xff0b6623);
  // static const appPrimaryColor = Color(0xff00b159);
  static const appSecondaryColor2 = Color(0xff708238);
  static const appSecondaryColor = Color(0xff8A9A5B);

  // static const appSecondaryColor = Color(0xffcc5500);
  static const appOpacity = 0.25;

  static const _defaultScreen = AuthScreen();

  // static const _defaultScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginUserData()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: appPrimaryColor,
            secondary: appSecondaryColor,
          ),
          appBarTheme: AppBarTheme(
            toolbarHeight: 70,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white, fontSize: 25.0, letterSpacing: 5.0),
          ).copyWith(
              iconTheme: const IconThemeData(size: 30.0, color: Colors.white)),
        ),
        home: _defaultScreen,
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
        },
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => _defaultScreen,
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => _defaultScreen,
        ),
      ),
    );
  }
}
