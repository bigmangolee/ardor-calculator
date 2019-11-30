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

import 'package:ardor_calculator/generated/i18n.dart';
import 'package:flutter/material.dart';

import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';

// ignore: must_be_immutable
class CalFinancial extends CalBase {
  CalFinancial(passwordInputCallback) : super(passwordInputCallback);

  @override
  String getName() {
    return S.current.calFinancial_name;
  }

  @override
  IconData getIcon() {
    return Icons.directions_bike;
  }

  @override
  void reset() {
    // TODO: implement reset
  }

  @override
  State<StatefulWidget> createState() {
    return _CalCalFinancialState();
  }
}

class _CalCalFinancialState extends State<CalFinancial> {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(S.current.tips_under_development),
        ],
      ),
    );
  }
}
