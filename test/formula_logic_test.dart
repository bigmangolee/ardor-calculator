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


import 'package:anise_calculator/app/anise/calculator/formula/formula.dart';
import 'package:anise_calculator/library/applog.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  //flutter test test/formula_logic_test.dart
  AppLog.isEnable = false;
  group('FormulaLogic', () {
    test('1+12', () {

      String onWarning;
      FormulaLogic formulaLogic = new FormulaLogic(
            (String msg) {onWarning =  msg;});

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+");

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1+1");

      formulaLogic.setCurrentNumber("12");
      expect(formulaLogic.toString(), "1+12");

      expect(formulaLogic.toString(), "1+12");

    });

    test('1+2+3×4×5-6÷8', () {

      String onWarning;
      FormulaLogic formulaLogic = new FormulaLogic(
              (String msg) {onWarning =  msg;});

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+2+");

      formulaLogic.setCurrentNumber("3");
      expect(formulaLogic.toString(), "1+2+3");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2+3×");

      formulaLogic.setCurrentNumber("4");
      expect(formulaLogic.toString(), "1+2+3×4");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2+3×4×");

      formulaLogic.setCurrentNumber("5");
      expect(formulaLogic.toString(), "1+2+3×4×5");

      formulaLogic.addFormula(new Formula(FormulaType.Minus));
      expect(formulaLogic.toString(), "1+2+3×4×5-");

      formulaLogic.setCurrentNumber("6");
      expect(formulaLogic.toString(), "1+2+3×4×5-6");

      formulaLogic.addFormula(new Formula(FormulaType.Devi));
      expect(formulaLogic.toString(), "1+2+3×4×5-6÷");

      formulaLogic.setCurrentNumber("8");
      expect(formulaLogic.toString(), "1+2+3×4×5-6÷8");

      expect(formulaLogic.toString(), "1+2+3×4×5-6÷8");

    });

    test('(1+2)×3+(((4+5)×6+(7-1)÷8)+9)', () {

      String onWarning;
      FormulaLogic formulaLogic = new FormulaLogic(
              (String msg) {onWarning =  msg;});

      formulaLogic.upPriorityWeight();
      expect(formulaLogic.toString(), "(");

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "(1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "(1+");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "(1+2");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "(1+2)×");

      formulaLogic.setCurrentNumber("3");
      expect(formulaLogic.toString(), "(1+2)×3");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "(1+2)×3+");

      formulaLogic.upPriorityWeight();
      formulaLogic.upPriorityWeight();
      formulaLogic.upPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((");

      formulaLogic.setCurrentNumber("4");
      expect(formulaLogic.toString(), "(1+2)×3+(((4");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+");

      formulaLogic.setCurrentNumber("5");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×");

      formulaLogic.setCurrentNumber("6");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+");

      formulaLogic.upPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(");

      formulaLogic.setCurrentNumber("7");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7");

      formulaLogic.addFormula(new Formula(FormulaType.Minus));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-");

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)");

      formulaLogic.addFormula(new Formula(FormulaType.Devi));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷");

      formulaLogic.setCurrentNumber("8");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8)");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8)+");

      formulaLogic.setCurrentNumber("9");
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8)+9");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8)+9)");

      expect(formulaLogic.toString(), "(1+2)×3+(((4+5)×6+(7-1)÷8)+9)");

      double v = formulaLogic.calculate();
      expect(v.toString(), "72.75");
    });

    test('1+2×3Square÷6-5', () {

      String onWarning;
      FormulaLogic formulaLogic = new FormulaLogic(
              (String msg) {onWarning =  msg;});

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2×");

      formulaLogic.setCurrentNumber("3");
      expect(formulaLogic.toString(), "1+2×3");

      formulaLogic.addFormula(new Formula(FormulaType.Square));
      expect(formulaLogic.toString(), "1+2×3Square");

      formulaLogic.addFormula(new Formula(FormulaType.Devi));
      expect(formulaLogic.toString(), "1+2×3Square÷");

      formulaLogic.setCurrentNumber("6");
      expect(formulaLogic.toString(), "1+2×3Square÷6");

      formulaLogic.addFormula(new Formula(FormulaType.Minus));
      expect(formulaLogic.toString(), "1+2×3Square÷6-");

      formulaLogic.setCurrentNumber("5");
      expect(formulaLogic.toString(), "1+2×3Square÷6-5");

      expect(formulaLogic.toString(), "1+2×3Square÷6-5");

      double v = formulaLogic.calculate();
      expect(v.toString(), "-1.0");
    });

    //多参数公式嵌套
    test('1+2<F4>(2×3Square÷6)-5(1+2×2)×2-1', () {
      String onWarning;
      FormulaLogic formulaLogic = new FormulaLogic(
              (String msg) {onWarning =  msg;});

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2");

      formulaLogic.addFormula(new Formula(FormulaType.F4));
      expect(formulaLogic.toString(), "1+2<F4>");

      formulaLogic.upPriorityWeight();
      expect(formulaLogic.toString(), "1+2<F4>(");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2<F4>(2");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2<F4>(2×");

      formulaLogic.setCurrentNumber("3");
      expect(formulaLogic.toString(), "1+2<F4>(2×3");

      formulaLogic.addFormula(new Formula(FormulaType.Square));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square");

      formulaLogic.addFormula(new Formula(FormulaType.Devi));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷");

      formulaLogic.setCurrentNumber("6");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)");

      formulaLogic.setCurrentNumber("-5");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5");

      formulaLogic.upPriorityWeight();
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(");

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1");

      formulaLogic.addFormula(new Formula(FormulaType.Plus));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2");

      formulaLogic.downPriorityWeight();
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2)");

      formulaLogic.addFormula(new Formula(FormulaType.Multi));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2)×");

      formulaLogic.setCurrentNumber("2");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2)×2");

      formulaLogic.addFormula(new Formula(FormulaType.Minus));
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2)×2-");

      formulaLogic.setCurrentNumber("1");
      expect(formulaLogic.toString(), "1+2<F4>(2×3Square÷6)-5(1+2×2)×2-1");

      //F4=a+b*c-d
      double v = formulaLogic.calculate();
      expect(v.toString(), "-36.0");
    });
  });


}