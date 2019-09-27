// Copyright 2019-present the Ardor.App authors. All Rights Reserved.
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

// ignore: must_be_immutable
class PasswordKeybordDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _PasswordKeybordDialogState();
  }
}


class _PasswordKeybordDialogState extends State<PasswordKeybordDialog> {

  Color backgroundColor;

  double elevation;

  Duration insetAnimationDuration = const Duration(milliseconds: 100);

  Curve insetAnimationCurve = Curves.decelerate;

  ShapeBorder shape;

  static const RoundedRectangleBorder _defaultDialogShape =
  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              color: backgroundColor ?? dialogTheme.backgroundColor ?? Theme.of(context).dialogBackgroundColor,
              elevation: elevation ?? dialogTheme.elevation ?? _defaultElevation,
              shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
              type: MaterialType.card,
              child: getContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getContent() {
    return new DefaultTabController(
      length: calculators.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: const Text('Old Password',style: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
          ),),
          bottom: new TabBar(
            isScrollable: true,
            tabs: calculators.map((CalBase cal) {
              return new Tab(
                text: cal.getName(),
                icon: new Icon(cal.getIcon()),
              );
            }).toList(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.input),
              tooltip: 'done',
              onPressed: (){},
            ),
            IconButton(
              icon: const Icon(Icons.cached),
              tooltip: 'cancel',
              onPressed: (){},
            ),
          ],
        ),

        body: new TabBarView(
          children: calculators.map((CalBase cal) {
            return new Padding(
              padding: const EdgeInsets.all(3.0),
              child: new ChoiceKeyboard(cal: cal),
            );
          }).toList(),
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

class ChoiceKeyboard extends StatelessWidget {
  const ChoiceKeyboard({ Key key, this.cal }) : super(key: key);

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

