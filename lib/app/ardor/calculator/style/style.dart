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

import 'package:ardor_calculator/app/ardor/calculator/style/style_simple.dart';
import 'package:flutter/material.dart';

class AppStyle {

  static AppStyle _appStyle = new StyleSimple();

  static AppStyle getAppStyle() {
    return _appStyle;
  }

  TextStyle _textField;

  TextStyle textField(bool isEnable) => _textField;

  DialogStyle _dialog;

  DialogStyle get dialog => _dialog;

}

class DialogStyle {

  TextStyle _titleText;

  TextStyle _contentText;

  TextStyle _buttonText;

  TextStyle get titleText => _titleText;

  TextStyle get contentText => _contentText;

  TextStyle get buttonText => _buttonText;

}
