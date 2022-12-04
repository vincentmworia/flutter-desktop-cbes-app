import 'dart:async';

import 'package:cbesdesktop/screens/offline_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/auto_connection_helper.dart';
import '../widgets/nav_bar_plane.dart';

import './dashboard_screen.dart';
import './admin_screen.dart';
import './heating_unit_screen.dart';
import './settings_screen.dart';
import './power_unit_screen.dart';
import './ubibot_screen.dart';

enum PageTitle { dashboard, heatingUnit, ubibot, powerUnit, admin, settings }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageTitle _page = PageTitle.dashboard;
  String _pageTitle = 'Dashboard';
  var _compressNavPlane = true;
  var _showNavPlane = true;

  // ConnectivityResult _connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  //
  // void _updateInternetState(ConnectivityResult result) {
  //   setState(() {
  //     _connectionStatus = result;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("HOME INITIALIZATION");
    }

    _page = PageTitle.dashboard;
// todo work on internet listener and reconnection offline/online
    // Future.delayed(Duration.zero).then((value) async =>
    //     _connectivitySubscription = await internetChecker(
    //         mounted: mounted,
    //         updateUi: _updateInternetState,
    //         connectivity: _connectivity,
    //         // context: context,
    //         // reInitializationActive: true
    //     ));
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('HOME DISPOSED');
    }
    // _connectivitySubscription?.cancel();
  }

  void _switchPage(PageTitle page, String title) {
    setState(() {
      _showNavPlane = false;
      _compressNavPlane = true;
      _page = page;
      _pageTitle = title;
    });
  }

  Widget _pageWidget(PageTitle page) {
    switch (page) {
      case PageTitle.dashboard:
        return const DashboardScreen();
      case PageTitle.heatingUnit:
        return const HeatingUnitScreen();
      case PageTitle.ubibot:
        return const UbibotScreen();
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(_pageTitle),
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: IconButton(
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
                    print(_showNavPlane);
                  }
                });
              },
              icon: const Icon(Icons.menu),
            ),
          ),
        ),
        body: Row(
          children: [
            AnimatedContainer(
              duration: duration,
              width: _compressNavPlane ? 0 : 100,
              height: double.infinity,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.99),
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
      ),
    );
  }
}
