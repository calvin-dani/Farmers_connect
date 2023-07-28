import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logintunisia/screens/dashboard_page.dart';
import 'package:logintunisia/screens/login_register_page.dart';

import 'auth.dart';
import 'screens/splash.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool showSplash = true; // add this

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // choose the duration of your splash screen
      setState(() {
        showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSplash) {
      return SplashScreen(); // return the splash screen if showSplash is true
    }

    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        // print(snapshot);
        if (snapshot.hasData) {
          return DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
