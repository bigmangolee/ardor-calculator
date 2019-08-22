// Copyright 2019-present the Anise.App authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:anise_calculator/app/anise/calculator/cal_general.dart';
import 'package:anise_calculator/app/anise/calculator/cal_base.dart';
import 'package:anise_calculator/app/anise/calculator/cal_financial.dart';
import 'package:anise_calculator/app/anise/calculator/cal_mathematicall.dart';

class CalHome extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anise Calculator',
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
      home: new DefaultTabController(
        length: calculators.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('Anise Calculator'),
            bottom: new TabBar(
              isScrollable: true,
              tabs: calculators.map((CalBase cal) {
                return new Tab(
                  text: cal.getName(),
                  icon: new Icon(cal.getIcon()),
                );
              }).toList(),
            ),

          ),
          body: new TabBarView(
            children: calculators.map((CalBase cal) {
              return new Padding(
                padding: const EdgeInsets.all(3.0),
                child: new ChoiceCalculator(cal: cal),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

List<CalBase> calculators = <CalBase>[
  CalGeneral(),
  CalMathematical(),
  CalFinancial(),
//  CalBlockChain(),
];

class ChoiceCalculator extends StatelessWidget {
  const ChoiceCalculator({ Key key, this.cal }) : super(key: key);

  final CalBase cal;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      child: new Center(
        child: cal,
      ),
    );
  }
}

