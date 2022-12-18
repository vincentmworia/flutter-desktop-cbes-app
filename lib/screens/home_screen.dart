import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/login_user_data.dart';
import './auth_screen.dart';
import './offline_screen.dart';
import '../widgets/nav_bar_plane.dart';
import './dashboard_screen.dart';
import './admin_screen.dart';
import './heating_unit_screen.dart';
import './settings_screen.dart';
import './power_unit_screen.dart';
import './environment_meter_screen.dart';

enum PageTitle {
  dashboard,
  heatingUnit,
  environmentMeter,
  powerUnit,
  admin,
  settings
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  static String pageTitle(PageTitle page) {
    switch (page) {
      case PageTitle.dashboard:
        return "Dashboard";
      case PageTitle.heatingUnit:
        return "Solar Heating Unit";
      case PageTitle.environmentMeter:
        return "Environment Meter";
      case PageTitle.powerUnit:
        return "Power Unit";
      case PageTitle.admin:
        return "Admin Screen";
      case PageTitle.settings:
        return "Settings";
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageTitle _page = PageTitle.dashboard;
  String _pageTitle = 'Dashboard';
  var _compressNavPlane = true;
  var _showNavPlane = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.ethernet;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("HOME INITIALIZATION");
      try {
        Future.delayed(Duration.zero)
            .then((value) async => await _connectivity.checkConnectivity())
            .then((value) => setState(() {
                  _connectionStatus = value;
                }));

        ConnectivityResult? prevResult;
        _connectivity.onConnectivityChanged.listen((result) async {
          if (prevResult != result && mounted) {
            Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            // if (prevResult == ConnectivityResult.none && mounted) {
            //   Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            // } else {
            //   prevResult = result;
            //   if (mounted) {
            //     setState(() {
            //       _connectionStatus = result;
            //     });
            //   }
            // }
          }
        });
      } on PlatformException catch (_) {
        if (kDebugMode) {
          print('Could n\'t check connectivity status');
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('HOME DISPOSED');
    }
    _connectivitySubscription?.cancel();
  }

  void _switchPage(PageTitle page, String title) {
    setState(() {
      // todo
      _showNavPlane = false;
      _compressNavPlane = true;
      _page = page;
      _pageTitle = title;
    });
  }

  Widget _pageWidget(PageTitle page) {
    switch (page) {
      case PageTitle.dashboard:
        return DashboardScreen(switchDashboardPage: _switchPage);
      case PageTitle.heatingUnit:
        return const HeatingUnitScreen();
      case PageTitle.environmentMeter:
        return const EnvironmentMeterScreen();
      case PageTitle.powerUnit:
        return const PowerUnitScreen();
      case PageTitle.admin:
        return const AdminScreen();
      case PageTitle.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final goodConnection = _connectionStatus == ConnectivityResult.ethernet ||
    //     _connectionStatus == ConnectivityResult.mobile ||
    //     _connectionStatus == ConnectivityResult.wifi;

    // print(_connectionStatus);
    // if (!goodConnection) {
    //   return const SafeArea(
    //       child: Scaffold(
    //     body: OfflineScreen(),
    //   ));
    // }

    const duration = Duration(milliseconds: 200);

    const txtStyle = TextStyle(
        color: Colors.white,
        // fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 3.0);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  _switchPage(PageTitle.dashboard,
                      HomeScreen.pageTitle(PageTitle.dashboard));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'images/cbes_logo2.PNG',
                    fit: BoxFit.cover,
                    width: 40,
                    // height: 50,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(_pageTitle),
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  _connectionStatus == ConnectivityResult.wifi
                      ? Icons.wifi
                      : _connectionStatus == ConnectivityResult.mobile
                          ? Icons.signal_cellular_alt
                          : _connectionStatus == ConnectivityResult.ethernet
                              ? Icons.cable
                              : Icons.signal_cellular_0_bar,
                  size: 30,
                  color: Colors.white,
                )),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                )),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Text(
                  '${LoginUserData.getLoggedUser!.firstname} ${LoginUserData.getLoggedUser!.lastname}',
                  overflow: TextOverflow.clip,
                  style: txtStyle,
                ),
              ),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: IconButton(
              disabledColor: Colors.white,
              color: Colors.white,
              hoverColor: Theme.of(context).colorScheme.primary,
              focusColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                setState(() {
                  _showNavPlane = false;
                  _compressNavPlane = !_compressNavPlane;
                });
                Future.delayed(duration).then((value) {
                  if (!_compressNavPlane) {
                    setState(() {
                      _showNavPlane = true;
                    });
                    // print(_showNavPlane);
                  }
                });
              },
              icon: Icon(_compressNavPlane ? Icons.menu : Icons.arrow_back),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('Images/Logo.ico'),
                        fit: BoxFit.cover)),
                child: ClipRRect(
                    child: Container(
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.9),
                ))),
            Row(
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: _compressNavPlane ? 0 : 110,
                  height: double.infinity,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.99),
                  child: Visibility(
                    visible: _showNavPlane,
                    child: NavBarPlane(
                      switchPage: _switchPage,
                      pageTitle: _page,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: _pageWidget(_page),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
