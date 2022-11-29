import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class WindowsWrapper extends StatelessWidget {
  const WindowsWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  static final buttonColors = WindowButtonColors(
    iconNormal: Colors.black,
    mouseOver: Colors.grey.withOpacity(0.75),
    iconMouseOver: Colors.white,
    mouseDown: Colors.grey,
    // mouseDown:Colors.white10,
  );

  static final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    iconNormal: Colors.black,
    iconMouseOver: Colors.white,
    mouseDown: const Color(0xFFB71C1C),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WindowBorder(
        color: Colors.white,
        width: 1,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      MyApp.appTitle,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  // const Text(MyApp.appTitle),
                  Expanded(child: MoveWindow()),
                  Row(
                    children: [
                      MinimizeWindowButton(colors: buttonColors),
                      MaximizeWindowButton(colors: buttonColors),
                      CloseWindowButton(colors: closeButtonColors),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: child)
          ],
        ),
      ),
    );
  }
}
