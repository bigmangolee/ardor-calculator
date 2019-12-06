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

enum GeometricTrigonometricUnit {
  //弧度
  Radians,
  //角度
  Angle,
}

//几何公式。
abstract class FormulaGeometric extends FormulaBase {
  static GeometricTrigonometricUnit trigonometricUnit = GeometricTrigonometricUnit.Radians;
  //弧度= 角度 * Math.PI / 180
  //角度 = 弧度 * 180 / Math.PI

  //获取弧度值。
  Decimal getRadiansValue(int index, Decimal def) {
    if (trigonometricUnit == GeometricTrigonometricUnit.Radians) {
      return getValue(index, def);
    } else {
      if (valueSize() > index) {
        //将角度转换为弧度。0.0174532925
        return Decimal.parse((double.parse(getValue(index, def).toString()) * double.parse(pi.toString()) / 180).toString());
      } else {
        return def;
      }
    }
  }
}

//sin
class Sin extends FormulaGeometric {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(sin(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(sin(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "Sin";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "sin";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//cos
class Cos extends FormulaGeometric {
  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(cos(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(cos(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "Cos";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "cos";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//tan
class Tan extends FormulaGeometric {
  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(tan(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(tan(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "Tan";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "tan";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//acos
class ACos extends FormulaGeometric {
  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(acos(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(acos(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "ACos";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "acos";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//asin
class ASin extends FormulaGeometric {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(asin(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(asin(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "ASin";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "asin";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//atan
class ATan extends FormulaGeometric {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(atan(double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    } else {
      return getValue(0, Decimal.one) * Decimal.parse(atan(double.parse(getRadiansValue(1, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "ATan";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "atan";
  }

  @override
  int valueCount() {
    return 2;
  }
}

//atan2
class ATan2 extends FormulaGeometric {

  @override
  Decimal operation() {
    if (valueSize() == 0) {
      return Decimal.zero;
    } else if (valueSize() == 1) {
      return Decimal.parse(atan2(double.parse(getRadiansValue(0, Decimal.one).toString()),1).toString());
    } else {
      return Decimal.parse(atan2(double.parse(getRadiansValue(0, Decimal.one).toString()),double.parse(getRadiansValue(0, Decimal.one).toString())).toString());
    }
  }

  @override
  String name() {
    return "ATan2";
  }

  @override
  int priority() {
    return 9;
  }

  @override
  String symbol() {
    return "atan2";
  }

  @override
  int valueCount() {
    return 2;
  }
}