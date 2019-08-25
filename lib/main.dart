import 'package:flutter/material.dart';

import 'package:anise_calculator/app/anise/calculator/cal_home.dart';

void main() => runApp(AniseApp());


class AniseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anise Calculator',
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => CalHome(),
      },
    );
  }
}
