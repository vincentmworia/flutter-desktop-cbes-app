import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class NavBarPlane extends StatefulWidget {
  const NavBarPlane(
      {Key? key, required this.switchPage, required this.pageTitle})
      : super(key: key);
  final PageTitle pageTitle;
  final Function switchPage;

  @override
  State<NavBarPlane> createState() => _NavBarPlaneState();
}

class _NavBarPlaneState extends State<NavBarPlane> {
  @override
  void initState() {
    super.initState();
    _activePage = widget.pageTitle;
  }

  PageTitle? _activePage;

  Widget _planeItem(PageTitle page, IconData icon) {
    const activeClr = Colors.lightGreenAccent;
    const inactiveClr = Colors.white;
    return GestureDetector(
        onTap: () {
          setState(() {
            _activePage = page;
          });

          widget.switchPage(page, HomeScreen.pageTitle(page));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          height: MediaQuery.of(context).size.height * 0.125,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: _activePage == page ? activeClr : inactiveClr,
              ),
              Expanded(
                child: Text(
                  HomeScreen.pageTitle(page),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    // fontSize: 1,
                    color: _activePage == page ? activeClr : inactiveClr,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<PageTitle, IconData>> planeData = [
      {PageTitle.dashboard: Icons.dashboard},
      {PageTitle.heatingUnit: Icons.heat_pump},
      {PageTitle.powerUnit: Icons.power_input},
      {PageTitle.ubibot: Icons.device_thermostat},
      {PageTitle.admin: Icons.admin_panel_settings},
      {PageTitle.settings: Icons.settings}
    ];
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: planeData
            .map((e) => _planeItem(e.keys.first, e.values.first))
            .toList(),
      ),
    );
  }
}
