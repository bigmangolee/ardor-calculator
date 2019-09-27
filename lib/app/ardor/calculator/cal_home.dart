// Copyright 2019-present the ardor.App authors. All Rights Reserved.
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
import 'package:ardor_calculator/app/ardor/calculator/cal_general.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_financial.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_mathematicall.dart';

import 'treasure/treasure_init_page.dart';

// ignore: must_be_immutable
class CalHome extends StatelessWidget {
  static bool _isCheckInitApp = false;
  @override
  Widget build(BuildContext context) {
    if(!_isCheckInitApp){
      checkInitApp(context);
      _isCheckInitApp = true;
    }
    return DefaultTabController(
      length: calculators.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: const Text('ardor Calculator'),
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
    );
  }

  void checkInitApp(BuildContext context){
    TreasureInit.toInit(context);
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

