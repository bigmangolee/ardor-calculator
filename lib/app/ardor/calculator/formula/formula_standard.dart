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
import 'dart:math';

import 'package:decimal/decimal.dart';

//加法公式
class Plus extends FormulaBase {
  @override
  Decimal operation() {
    return getValue(0, Decimal.zero) + getValue(1, Decimal.zero);
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
  Decimal operation() {
    return getValue(0, Decimal.zero) - getValue(1, Decimal.zero);
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
  Decimal operation() {
    return getValue(0, Decimal.one) * getValue(1, Decimal.one);
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
  Decimal operation() {
    return getValue(0, Decimal.one) / getValue(1, Decimal.one);
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
  Decimal operation() {
    return getValue(0, Decimal.zero) / Decimal.parse("100") ;
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

//幂运算
class Pow extends FormulaBase {
  @override
  Decimal operation() {
    return  Decimal.parse(pow(double.parse(getValue(0, Decimal.one).toString()) ,double.parse(getValue(1, Decimal.one).toString())).toString());
  }

  @override
  String name() {
    return "Pow";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "pow";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//开平方根
class Sqrt extends FormulaBase {
  @override
  Decimal operation() {
    return Decimal.parse(sqrt(double.parse(getValue(0, Decimal.one).toString())).toString());
  }

  @override
  String name() {
    return "Sqrt";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "sqrt";
  }

  @override
  int valueCount() {
    return 1;
  }
}

//开平
class Square extends FormulaBase {
  @override
  Decimal operation() {
    return getValue(0, Decimal.one) * getValue(0, Decimal.one);
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
    return "square";
  }

  @override
  int valueCount() {
    return 1;
  }
}

//exp
class Exp extends FormulaBase {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(exp(double.parse(getValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(exp(double.parse(getValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "Exp";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "exp";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//log
class Log extends FormulaBase {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(log(double.parse(getValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(log(double.parse(getValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "Log";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "log";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//3参数公式
class F3 extends FormulaBase {
  @override
  Decimal operation() {
    return getValue(0, Decimal.one) + getValue(1, Decimal.one) * getValue(2, Decimal.one);
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
  Decimal operation() {
    return getValue(0, Decimal.one) + getValue(1, Decimal.one) * getValue(2, Decimal.one) - getValue(3, Decimal.zero);
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
  Decimal operation() {
    return getValue(0, Decimal.one) +
        getValue(1, Decimal.one) * getValue(2, Decimal.one) -
        getValue(3, Decimal.zero) / (Decimal.one + getValue(4, Decimal.zero));
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