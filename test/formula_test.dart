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
  //flutter test test/formula_test.dart
  AppLog.isEnable = false;
  group('Formula', () {
    test('Input case 1', () {
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

      _formulaController.input(".");
      expect(onInputDisplay, "123.");

      _formulaController.input(4);
      expect(onInputDisplay, "123.4");

      _formulaController.input(".");
      expect(onInputDisplay, "123.4");
      expect(onWarning, "非数字！");

      _formulaController.input(FormulaAction.Clean);
      expect(onInputDisplay, "");

      _formulaController.input(".");
      expect(onInputDisplay, "0.");

      _formulaController.input(5);
      expect(onInputDisplay, "0.5");

      _formulaController.input(6);
      expect(onInputDisplay, "0.56");
    });

    test('Number input case 2', () {
      String onTools;
      String onInputDisplay;
      String onOutputDisplay;
      String onWarning;
      FormulaController _formulaController = new FormulaController(
            (String msg) {onTools =  msg;},
            (String msg) {onInputDisplay =  msg;},
            (String msg) {onOutputDisplay =  msg;},
            (String msg) {onWarning =  msg;},);

      _formulaController.input(1).input(2).input(3).input(".").input(4);
      _formulaController.input(FormulaAction.Delete);
      expect(onInputDisplay, "123.4");

    });

    test('MemoryOpera', () {
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
      expect(onWarning, "Memory cache is empty.");
    });

    test('Formula: 1+2+3×4×5+6-7-8+9÷10+11-12×13 = 221.9', () {
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

      _formulaController.input(FormulaType.Plus);
      expect(onInputDisplay, "1+");

      _formulaController.input(2);
      expect(onInputDisplay, "1+2");

      _formulaController.input(FormulaType.Plus);
      expect(onInputDisplay, "1+2+");

      _formulaController.input(3);
      expect(onInputDisplay, "1+2+3");

      _formulaController.input(FormulaType.Multi);
      expect(onInputDisplay, "1+2+3×");

      _formulaController.input(4);
      expect(onInputDisplay, "1+2+3×4");

      _formulaController.input(FormulaType.Multi);
      expect(onInputDisplay, "1+2+3×4×");

      _formulaController.input(5);
      expect(onInputDisplay, "1+2+3×4×5");

      _formulaController.input(FormulaType.Plus);
      expect(onInputDisplay, "1+2+3×4×5+");

      _formulaController.input(6);
      expect(onInputDisplay, "1+2+3×4×5+6");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "69");

    });

    test('Exception case 1', () {
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
      expect(onWarning, isNotEmpty);

    });

    test('Formula case 2', () {
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
      _formulaController.input(FormulaType.Percent);
      expect(onInputDisplay, "12%");

      _formulaController.input(FormulaAction.Calculate);
      expect(onOutputDisplay, "0.12");
    });

  });


}