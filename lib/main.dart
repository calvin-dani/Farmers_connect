import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logintunisia/screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.blue),
      ),
      home: LoginScreen(),
    );
  }
}
