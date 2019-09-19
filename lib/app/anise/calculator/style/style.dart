

import 'package:anise_calculator/app/anise/calculator/style/style_simple.dart';
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
