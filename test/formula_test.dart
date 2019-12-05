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
import 'package:ardor_calculator/app/ardor/calculator/formula/formula_geometric.dart';
import 'package:ardor_calculator/app/ardor/calculator/formula/formula_standard.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  //flutter test test/formula_test.dart
  AppLog.isEnable = false;
  group('Formula', () {
    test('Formula case 1 ：Input', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(1);
      expect(onInputDisplay, "1");

      _formulaController.input(2);
      expect(onInputDisplay, "12");

      _formulaController.input(3);
      expect(onInputDisplay, "123");

      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "");


      _formulaController.input(123);
      _formulaController.input(".");
      expect(onInputDisplay, "123.");

      _formulaController.input(4);
      expect(onInputDisplay, "123.4");

      _formulaController.input(".");
      expect(onInputDisplay, "123.4");
      expect(onWarning, S.current?.formula_warning_not_a_legitimate_number);

      _formulaController.input(FormulaAction.Clean);
      expect(onInputDisplay, "");

      _formulaController.input(".");
      expect(onInputDisplay, "0.");

      _formulaController.input(5);
      expect(onInputDisplay, "0.5");

      _formulaController.input(6);
      expect(onInputDisplay, "0.56");
    });


    test('Formula case 2 ：MemoryOpera', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(89);
      expect(onInputDisplay, "89");

      _formulaController.input(MemoryOpera.Add);
      expect(onTools, MemoryOpera.Add.toString());

      _formulaController.input(FormulaAction.Clean);
      expect(onInputDisplay, "");

      _formulaController.input(MemoryOpera.Read);
      expect(onTools, MemoryOpera.Read.toString());
      expect(onInputDisplay, "89");

      //Memory Plus test
      _formulaController.input(MemoryOpera.Plus);
      expect(onInputDisplay, "89+89");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "178");

      _formulaController.input(FormulaAction.Clean);
      _formulaController.input(100);

      //Memory Plus test
      _formulaController.input(MemoryOpera.Minus);
      expect(onInputDisplay, "100-89");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "11");

      _formulaController.input(MemoryOpera.Clean);
      _formulaController.input(MemoryOpera.Read);
      expect(onWarning, S.current?.formula_warning_memory_cache_is_empty);
    });

    test('Formula case 3 ： 1+2+3×4×5+6-7-8+9÷10+11-12×13 = 221.9', () {
      String onTools = "";
      String onInputDisplay = "";
      String onOutputDisplay = "";
      String onWarning = "";
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(1);
      expect(onInputDisplay, "1");

      _formulaController.input(Plus());
      expect(onInputDisplay, "1+");

      _formulaController.input(2);
      expect(onInputDisplay, "1+2");

      _formulaController.input(Plus());
      expect(onInputDisplay, "1+2+");

      _formulaController.input(3);
      expect(onInputDisplay, "1+2+3");

      _formulaController.input(Multi());
      expect(onInputDisplay, "1+2+3×");

      _formulaController.input(4);
      expect(onInputDisplay, "1+2+3×4");

      _formulaController.input(Multi());
      expect(onInputDisplay, "1+2+3×4×");

      _formulaController.input(5);
      expect(onInputDisplay, "1+2+3×4×5");

      _formulaController.input(Plus());
      expect(onInputDisplay, "1+2+3×4×5+");

      _formulaController.input(6);
      expect(onInputDisplay, "1+2+3×4×5+6");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "69");

    });

    test('Formula case 4：Exception ', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(null);
      expect(onWarning, null);

    });

    test('Formula case 5 ：Percent()', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(12);
      _formulaController.input(Multi());
      _formulaController.input(FormulaAction.UpPriority);
      _formulaController.input(2);
      _formulaController.input(Plus());
      _formulaController.input(3);
      _formulaController.input(FormulaAction.DownPriority);
      _formulaController.input(Percent());
      expect(onInputDisplay, "12×(2+3)%");
      _formulaController.input(FormulaAction.Calculate);

      expect(onOutputDisplay, "0.6");
    });


    test('Formula case 6 ：FormulaAction.Delete test case 1', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(8).input(8).input(8);
      _formulaController.input(Plus());
      _formulaController.input(9).input(9).input(9);
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(Plus());
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(Plus());
      _formulaController.input(9).input(9).input(9);
      expect(onInputDisplay, "888+9+999");

      _formulaController.input(Plus());
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(Plus());
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(Plus());
      expect(onInputDisplay, "888+9+99+");

      _formulaController.input(FormulaAction.Delete);
      _formulaController.input(Multi());
      _formulaController.input(9);
      _formulaController.input(Square());
      expect(onInputDisplay, "888+9+99×9square");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "8916");

    });

    test('Formula case 7 ：FormulaAction.Delete test case 2', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(12);
      _formulaController.input(Multi());
      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "12");

      _formulaController.input(Multi());
      expect(onInputDisplay, "12×");

      _formulaController.input(FormulaAction.UpPriority);
      expect(onInputDisplay, "12×(");

      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "12×");

      _formulaController.input(FormulaAction.UpPriority);
      expect(onInputDisplay, "12×(");

      _formulaController.input(2);
      _formulaController.input(Plus());
      _formulaController.input(3);
      _formulaController.input(FormulaAction.DownPriority);
      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "12×(2+3");

      _formulaController.input(FormulaAction.DownPriority);
      expect(onInputDisplay, "12×(2+3)");

      _formulaController.input(Percent());
      expect(onInputDisplay, "12×(2+3)%");

      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "12×(2+3)");

      _formulaController.input(Percent());
      expect(onInputDisplay, "12×(2+3)%");

      _formulaController.input(FormulaAction.Calculate);

      expect(onOutputDisplay, "0.6");
    });

    test('Formula case 8 ： test case 3', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input(2);
      _formulaController.input(Plus());
      _formulaController.input(3);
      _formulaController.input(FormulaAction.Calculate);
      _formulaController.input(0);
      expect(onInputDisplay, "1+2+30");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "33");
    });

    test('Formula case 9 ： test Negative operation', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input("-");
      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onInputDisplay, "-1+2");
      expect(onOutputDisplay, "1");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input("-");
      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input("-");
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onInputDisplay, "-1+-2");
      expect(onOutputDisplay, "-3");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Minus());
      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onInputDisplay, "-1+2");
      expect(onOutputDisplay, "1");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Minus());
      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input(Minus());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onInputDisplay, "-1-2");
      expect(onOutputDisplay, "-3");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Minus());
      _formulaController.input(1);
      _formulaController.input(Plus());
      _formulaController.input(FormulaAction.UpPriority);
      _formulaController.input(Minus());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onInputDisplay, "-1+(-2");
      expect(onOutputDisplay, "-3");
    });

    test('Formula case 10 ： test standard formula', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(3);
      _formulaController.input(Pow());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "9");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(16);
      _formulaController.input(Sqrt());
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "4");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(6);
      _formulaController.input(Square());
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "36");
    });


    test('Formula case 11 ： test Trigonometric formula', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;

      FormulaGeometric.trigonometricUnit = GeometricTrigonometricUnit.Angle;

      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(Sin());
      _formulaController.input(1);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.01745240643728351");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Sin());
      _formulaController.input(30);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.49999999999999994");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Sin());
      _formulaController.input(750);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.4999999999999991");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Cos());
      _formulaController.input(30);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.8660254037844387");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Tan());
      _formulaController.input(2);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.03492076949174773");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(Tan());
      _formulaController.input(45);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.9999999999999999");


      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(ASin());
      _formulaController.input(30);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.5510695830994463");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(ACos());
      _formulaController.input(30);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "1.0197267436954502");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(ATan());
      _formulaController.input(45);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.6657737500283538");

      _formulaController.input(FormulaAction.Clean);

      _formulaController.input(2);
      _formulaController.input(Sin());
      _formulaController.input(30);
      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.9999999999999999");
    });

  });


}