



import 'package:ardor_calculator/app/ardor/calculator/style/style.dart';
import 'package:flutter/material.dart';

class StyleSimple implements AppStyle {

  @override
  DialogStyle get dialog => DialogStyleSimple();

  @override
  TextStyle textField(bool isEnable) {
    return new TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w700,
      color: isEnable ? Colors.black87 : Colors.black12,
    );
  }
}

class DialogStyleSimple implements DialogStyle {

  @override
  TextStyle get contentText => new TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );

  @override
  TextStyle get titleText => new TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w700,
  );

  @override
  TextStyle get buttonText => new TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

}