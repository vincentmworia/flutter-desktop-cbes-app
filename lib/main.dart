import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';

import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './providers/login_user_data.dart';
import './providers/mqtt.dart';

void main() async {
  runApp(const MyApp());
  // todo Lock orientation
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1000, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = MyApp.appTitle;
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'CBES DASHBOARD';
  static const appPrimaryColor = Color(0xff00b159);
  static const appSecondaryColor = Color(0xff000000);
  static const appOpacity = 0.25;

  static const _defaultScreen = AuthScreen();

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
          ).copyWith(iconTheme: const IconThemeData(size: 30.0)),
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
