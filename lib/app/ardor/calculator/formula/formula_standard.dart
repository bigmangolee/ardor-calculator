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

import 'package:ardor_calculator/app/ardor/calculator/formula/formula.dart';

//加法公式
class Plus extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 0) + getValue(1, 0);
  }

  @override
  String name() {
    return "+";
  }

  @override
  int priority() {
    return 1;
  }

  @override
  String symbol() {
    return "+";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//减法公式
class Minus extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 0) - getValue(1, 0);
  }

  @override
  String name() {
    return "-";
  }

  @override
  int priority() {
    return 1;
  }

  @override
  String symbol() {
    return "-";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//乘法公式
class Multi extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) * getValue(1, 1);
  }

  @override
  String name() {
    return "×";
  }

  @override
  int priority() {
    return 2;
  }

  @override
  String symbol() {
    return "×";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//除法公式
class Devi extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) / getValue(1, 1);
  }

  @override
  String name() {
    return "÷";
  }

  @override
  int priority() {
    return 2;
  }

  @override
  String symbol() {
    return "÷";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//百分号运算
class Percent extends FormulaBase {

  @override
  double operation() {
    return getValue(0, 0) / 100 ;
  }

  @override
  String name() {
    return "Percent";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "%";
  }

  @override
  int valueCount() {
    return 1;
  }
}

//平方
class Square extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) * getValue(0, 1);
  }

  @override
  String name() {
    return "Square";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "Square";
  }

  @override
  int valueCount() {
    return 1;
  }
}

//3参数公式
class F3 extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) + getValue(1, 1) * getValue(2, 1);
  }

  @override
  String name() {
    return "<F3>";
  }

  @override
  int priority() {
    return 3;
  }

  @override
  String symbol() {
    return "<F3>";
  }

  @override
  int valueCount() {
    return 3;
  }
}

//4参数公式
class F4 extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) + getValue(1, 1) * getValue(2, 1) - getValue(3, 0);
  }

  @override
  String name() {
    return "<F4>";
  }

  @override
  int priority() {
    return 4;
  }

  @override
  String symbol() {
    return "<F4>";
  }

  @override
  int valueCount() {
    return 4;
  }
}

//5参数公式
class F5 extends FormulaBase {
  @override
  double operation() {
    return getValue(0, 1) +
        getValue(1, 1) * getValue(2, 1) -
        getValue(3, 0) / (1 + getValue(4, 0));
  }

  @override
  String name() {
    return "<F5>";
  }

  @override
  int priority() {
    return 5;
  }

  @override
  String symbol() {
    return "<F5>";
  }

  @override
  int valueCount() {
    return 5;
  }
}