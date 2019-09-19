import 'package:flutter/material.dart';

import 'package:anise_calculator/app/anise/calculator/cal_home.dart';

import 'app/anise/treasure/account_page.dart';
import 'app/anise/treasure/group_page.dart';

void main() => runApp(AniseApp());


class AniseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anise Calculator',
      // MaterialApp contains our top-level Navigator
      initialRoute: '/group',
      routes: {
        '/': (BuildContext context) => CalHome(),
        '/group': (BuildContext context) => GroupHomePage(),
        '/account': (BuildContext context) => AccountHomePage(),
      },
    );
  }
}
