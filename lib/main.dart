import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:logintunisia/screens/loginScreen.dart';
import 'package:logintunisia/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCNScBc7CS_VQ600mQn0FyRRaLsHz9voSw",
      appId: "1:431421130883:android:03c20031335144d5c1b3b6",
      messagingSenderId: "431421130883",
      projectId: "farmersconnect-21f53",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp(
    //   title: 'Flutter Demo',
    //   theme: theme.copyWith(
    //     colorScheme: theme.colorScheme.copyWith(secondary: Colors.blue),
    //   ),
    //   home: LoginScreen(),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const WidgetTree()
    );
  }
}
