import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logintunisia/firebase_options.dart';
// import 'package:get/get.dart';
// import 'package:logintunisia/screens/loginScreen.dart';
import 'package:logintunisia/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const WidgetTree());
  }
}
