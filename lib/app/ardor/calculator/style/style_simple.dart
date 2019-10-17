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