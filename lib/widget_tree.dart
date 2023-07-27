

import 'package:flutter/material.dart';
import 'package:logintunisia/screens/dashboard_page.dart';
import 'package:logintunisia/screens/home_page.dart';
import 'package:logintunisia/screens/login_register_page.dart';

import 'auth.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree ({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree>{

  @override
  Widget build(BuildContext context){
    return StreamBuilder(stream: Auth().authStateChanges,
    builder: (context,snapshot){
      // print(snapshot);
      if(snapshot.hasData){
        return DashboardPage();
      }
      else{
        return const LoginPage();
      }
    }
    );
  }
}