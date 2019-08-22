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

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('General Cal', () {
    // 通过 Finders 找到对应的 Widgets
    final tool_info=find.byValueKey('tool_info');
    final input_display=find.byValueKey('input_display');
    final out_display=find.byValueKey('out_display');
    final input_0=find.byValueKey('input_0');
    final input_1=find.byValueKey('input_1');
    final input_2=find.byValueKey('input_2');
    final input_3=find.byValueKey('input_3');
    final input_4=find.byValueKey('input_4');
    final input_5=find.byValueKey('input_5');
    final input_6=find.byValueKey('input_6');
    final input_7=find.byValueKey('input_7');
    final input_8=find.byValueKey('input_8');
    final input_9=find.byValueKey('input_9');
    final input_point=find.byValueKey('input_.');
    final input_perce=find.byValueKey('input_%');
    final btn_memory_opera_ma=find.byValueKey('MemoryOpera.Add');
    final btn_memory_opera_mc=find.byValueKey('MemoryOpera.Clean');
    final btn_memory_opera_mp=find.byValueKey('MemoryOpera.Plus');
    final btn_memory_opera_mm=find.byValueKey('MemoryOpera.Minus');
    final btn_memory_opera_mr=find.byValueKey('MemoryOpera.Read');

    final btn_formula_type_plus=find.byValueKey('FormulaType.Plus');
    final btn_formula_type_minus=find.byValueKey('FormulaType.Minus');
    final btn_formula_type_multi=find.byValueKey('FormulaType.Multi');
    final btn_formula_type_devi=find.byValueKey('FormulaType.Devi');

    final btn_action_clean=find.byValueKey('FormulaAction.Clean');
    final btn_action_delete=find.byValueKey('FormulaAction.Delete');
    final btn_action_calculate=find.byValueKey('FormulaAction.Calculate');

    FlutterDriver driver;

    // 连接 Flutter driver
    setUpAll(() async {
      driver=await FlutterDriver.connect();
    });

    // 当测试完成断开连接
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts at input display is empty', () async {
      expect(await driver.getText(input_display), "");
    });

    test('input 10', () async {
      await driver.tap(input_1);
      await driver.tap(input_0);
      expect(await driver.getText(input_display), "10");
    });

    test('FormulaAction.Clean', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");
    });

    test('1+1=2', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_1);
      expect(await driver.getText(input_display), "1");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+");

      await driver.tap(input_1);
      expect(await driver.getText(input_display), "1+1");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "2");
    });

    test('3-2=1', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_3);
      expect(await driver.getText(input_display), "3");

      await driver.tap(btn_formula_type_minus);
      expect(await driver.getText(input_display), "3-");

      await driver.tap(input_2);
      expect(await driver.getText(input_display), "3-2");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "1");
    });

    test('3×2=6', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_3);
      expect(await driver.getText(input_display), "3");

      await driver.tap(btn_formula_type_multi);
      expect(await driver.getText(input_display), "3×");

      await driver.tap(input_2);
      expect(await driver.getText(input_display), "3×2");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "6");
    });

    test('8÷2=4', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_8);
      expect(await driver.getText(input_display), "8");

      await driver.tap(btn_formula_type_devi);
      expect(await driver.getText(input_display), "8÷");

      await driver.tap(input_2);
      expect(await driver.getText(input_display), "8÷2");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "4");
    });

    test('1+2+3×4=15', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_1);
      expect(await driver.getText(input_display), "1");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+");

      await driver.tap(input_2);
      expect(await driver.getText(input_display), "1+2");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+2+");

      await driver.tap(input_3);
      expect(await driver.getText(input_display), "1+2+3");

      await driver.tap(btn_formula_type_multi);
      expect(await driver.getText(input_display), "1+2+3×");

      await driver.tap(input_4);
      expect(await driver.getText(input_display), "1+2+3×4");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "15");
    });

    test('1+2+3×4×5+6-7-8+9÷10+11-12×13=-90.1', () async {
      await driver.tap(btn_action_clean);
      expect(await driver.getText(input_display), "");

      await driver.tap(input_1);
      expect(await driver.getText(input_display), "1");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+");

      await driver.tap(input_2);
      expect(await driver.getText(input_display), "1+2");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+2+");

      await driver.tap(input_3);
      expect(await driver.getText(input_display), "1+2+3");

      await driver.tap(btn_formula_type_multi);
      expect(await driver.getText(input_display), "1+2+3×");

      await driver.tap(input_4);
      expect(await driver.getText(input_display), "1+2+3×4");

      await driver.tap(btn_formula_type_multi);
      expect(await driver.getText(input_display), "1+2+3×4×");

      await driver.tap(input_5);
      expect(await driver.getText(input_display), "1+2+3×4×5");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+2+3×4×5+");

      await driver.tap(input_6);
      expect(await driver.getText(input_display), "1+2+3×4×5+6");

      await driver.tap(btn_formula_type_minus);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-");

      await driver.tap(input_7);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7");

      await driver.tap(btn_formula_type_minus);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-");

      await driver.tap(input_8);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+");

      await driver.tap(input_9);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9");

      await driver.tap(btn_formula_type_devi);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷");

      await driver.tap(input_1);
      await driver.tap(input_0);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10");

      await driver.tap(btn_formula_type_plus);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+");

      await driver.tap(input_1);
      await driver.tap(input_1);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+11");

      await driver.tap(btn_formula_type_minus);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+11-");

      await driver.tap(input_1);
      await driver.tap(input_2);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+11-12");

      await driver.tap(btn_formula_type_multi);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+11-12×");

      await driver.tap(input_1);
      await driver.tap(input_3);
      expect(await driver.getText(input_display), "1+2+3×4×5+6-7-8+9÷10+11-12×13");

      await driver.tap(btn_action_calculate);
      expect(await driver.getText(out_display), "-90.1");
    });

  });
}