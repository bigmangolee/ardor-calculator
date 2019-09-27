import 'package:flutter/material.dart';

import 'package:anise_calculator/app/anise/calculator/cal_home.dart';

import 'app/anise/treasure/account_page.dart';
import 'app/anise/treasure/group_page.dart';

void main() => runApp(AniseApp());


class AniseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => CalHome(),
        '/group': (BuildContext context) => GroupHomePage(),
        '/account': (BuildContext context) => AccountHomePage(),
      },
    );
  }
}
