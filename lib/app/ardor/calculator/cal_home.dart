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

import 'package:ardor_calculator/app/ardor/calculator/cal_blockchain.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/store_manager.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/store/user_data_store.dart';
import 'package:ardor_calculator/app/ardor/calculator/treasure/treasure_init.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:flutter/material.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_general.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_financial.dart';
import 'package:ardor_calculator/app/ardor/calculator/cal_mathematicall.dart';

// ignore: must_be_immutable
class CalHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalHomeState();
  }
}

class _CalHomeState extends State<CalHome> {
  static bool _isCheckInitApp = false;

  BuildContext _context;
  List<CalBase> calculators;

  _CalHomeState() {
    initCalculators();
  }

  @override
  Widget build(BuildContext context) {
    initCalculators();
    _context = context;
    if (!_isCheckInitApp) {
      checkInitApp(context);
      _isCheckInitApp = true;
    }
    return DefaultTabController(
      length: calculators.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: Text(S.of(context).app_name),
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

  void checkInitApp(BuildContext context) {
    TreasureInit.toInit(context);
  }

  void initCalculators() {
    if (calculators == null) {
      calculators = <CalBase>[
        CalGeneral((String p) {
          startTreasure(p);
        }),
        CalMathematical((String p) {
          startTreasure(p);
        }),
        CalFinancial((String p) {
          startTreasure(p);
        }),
        CalBlockChain((String p) {
          startTreasure(p);
        }),
      ];
    }
  }

  Future<void> startTreasure(String p) async {
    StoreManager.secretKey = p;
    UserDataStore value = await StoreManager.getUserData();
    AppLog.i(tag, "startTreasure value: $value");
    if (value != null) {
      Navigator.pushNamed(_context, '/group');
    } else {
      //密码校验失败
      ArdorToast.show(S.of(context).home_tips_check_failure);
    }
  }
}

class ChoiceCalculator extends StatelessWidget {
  const ChoiceCalculator({Key key, this.cal}) : super(key: key);

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
