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

import 'package:anise_calculator/library/applog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:anise_calculator/app/anise/calculator/cal_base.dart';
import 'formula/formula.dart';


typedef CalculatorCallback = void Function(String key);
typedef CalculatorCallbackInt = void Function(int key);
typedef CalculatorCallbackDynamic = void Function(dynamic key);

// ignore: must_be_immutable
class CalGeneral extends CalBase {
  static final String _tag = "CalGeneral";
  FormulaController _formulaController;

  ToolInfo _toolInfo = new ToolInfo();
  InputDisplay _inputInfo = new InputDisplay();
  OutDisplay _outputInfo = new OutDisplay();

  CalGeneral(){
    _formulaController = new FormulaController(
          (String msg) {onTools(msg);},
          (String msg) {onInputDisplay(msg);},
          (String msg) {onOutputDisplay(msg);},
          (String msg) {onWarning(msg);},
    );
  }

  @override
  String getName() {
    return "General";
  }

  @override
  IconData getIcon() {
    return Icons.directions_car;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            alignment: Alignment.centerRight,
            child: _toolInfo,
          ),
          new Expanded(
              flex: 1,
              child: Container(
                child: _inputInfo,
              )),
          new Expanded(
              flex: 1,
              child: Container(
                child: _outputInfo,
              )),
          new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new MemoryOperation(MemoryOpera.Add, (dynamic key) {
                  onKey(key);
                }),
                new MemoryOperation(MemoryOpera.Plus, (dynamic key) {
                  onKey(key);
                }),
                new MemoryOperation(MemoryOpera.Minus, (dynamic key) {
                  onKey(key);
                }),
                new MemoryOperation(MemoryOpera.Read, (dynamic key) {
                  onKey(key);
                }),
              ]),
          new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new _CleanOperation(() {
                  onKey(FormulaAction.Clean);
                }),
                new _MathOperation(FormulaType.Devi, (dynamic key) {
                  onKey(key);
                }),
                new _MathOperation(FormulaType.Multi, (dynamic key) {
                  onKey(key);
                }),
                new _DeleteOperation(() {
                  onKey(FormulaAction.Delete);
                }),
              ]),
          new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new _CalInput(7, (int key) {
                  onKey(key);
                }),
                new _CalInput(8, (int key) {
                  onKey(key);
                }),
                new _CalInput(9, (int key) {
                  onKey(key);
                }),
                new _MathOperation(FormulaType.Minus, (dynamic key) {
                  onKey(key);
                }),
              ]),
          new Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new _CalInput(4, (int key) {
                  onKey(key);
                }),
                new _CalInput(5, (int key) {
                  onKey(key);
                }),
                new _CalInput(6, (int key) {
                  onKey(key);
                }),
                new _MathOperation(FormulaType.Plus, (dynamic key) {
                  onKey(key);
                }),
              ]),
          new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new _CalInput(1, (int key) {
                              onKey(key);
                            }),
                            new _CalInput(2, (int key) {
                              onKey(key);
                            }),
                            new _CalInput(3, (int key) {
                              onKey(key);
                            }),
                          ]),
                      new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new _CalPercent(() {
                              onKey(FormulaType.Percent);
                            }),
                            new _CalInput(0, (int key) {
                              onKey(key);
                            }),
                            new _CalPoint((String key) {
                              onKey(key);
                            }),
                          ]),
                    ]),
                new _CalculateOperation(() {
                  onKey(FormulaAction.Calculate);
                }),
              ]),
        ],
      ),
    );
  }

  void onKey(dynamic key) {
    _formulaController.input(key);
    AppLog.d(_tag, key.toString());
  }

  void onTools(String msg) {
    _toolInfo.onOpera(msg);
  }

  void onInputDisplay(String msg) {
    _inputInfo.setText(msg);
  }

  void onOutputDisplay(String msg) {
    _outputInfo.setText(msg);
  }

  void onWarning(String msg) {
    showToast(msg);
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor:Colors.lime[100],
      textColor:Colors.deepOrange,
    );
  }
}

const double buttonHeight = 60;
const double buttonWidth = 83;

// ignore: must_be_immutable
class ToolInfo extends StatefulWidget {
  _ToolInfo _toolInfo;

  void onOpera(String op) {
    _toolInfo.setTextInfo(op);
  }

  @override
  State<StatefulWidget> createState() {
    _toolInfo = new _ToolInfo();
    return _toolInfo;
  }
}

class _ToolInfo extends State<ToolInfo> {
  String _info = "";

  @override
  Widget build(BuildContext context) {
    return new Text(_info,
        key:Key('tool_info'),
        style: new TextStyle());
  }

  void setTextInfo(String info) {
    setState(() {
      _info = info;
    });
  }
}

class InputDisplay extends StatefulWidget {
  _InputDisplay __inputDisplay;

  void setText(String content) {
    __inputDisplay.setTextInfo(content);
  }

  @override
  State<StatefulWidget> createState() {
    __inputDisplay = new _InputDisplay();
    return __inputDisplay;
  }
}

class _InputDisplay extends State<InputDisplay> {
  String _info = "";

  @override
  Widget build(BuildContext context) {
//    return new TextField(
//      key:Key('input_display'),
//      enabled: false,
//      maxLines:10,//最大行数
//      maxLength:100,
//      controller: TextEditingController.fromValue(TextEditingValue(
//        // 设置内容
//          text: _info,
//          // 保持光标在最后
//          selection: TextSelection.fromPosition(TextPosition(
//              affinity: TextAffinity.downstream, offset: _info.length)))),
//      style: new TextStyle(fontSize: 20),
//    );
    return new Text(
        _info,
      key:Key('input_display'),
    );
  }

  void setTextInfo(String info) {
    setState(() {
      _info = info;
    });
  }
}

// ignore: must_be_immutable
class OutDisplay extends StatefulWidget {
  _OutDisplay __outDisplay;

  void setText(String content) {
    __outDisplay.setTextInfo(content);
  }

  @override
  State<StatefulWidget> createState() {
    __outDisplay = new _OutDisplay();
    return __outDisplay;
  }
}

class _OutDisplay extends State<OutDisplay> {
  String _info = "";

  @override
  Widget build(BuildContext context) {
//    return new TextField(
//      key:Key('out_display'),
//      enabled: false,
//      maxLines:10,//最大行数
//      maxLength:100,
//      controller: TextEditingController.fromValue(TextEditingValue(
//          // 设置内容
//          text: _info,
//          // 保持光标在最后
//          selection: TextSelection.fromPosition(TextPosition(
//              affinity: TextAffinity.downstream, offset: _info.length)))),
//      style: new TextStyle(fontSize: 20),
//    );
    return new Text(
      _info,
      key:Key('out_display'),
    );
  }

  void setTextInfo(String info) {
    setState(() {
      _info = info;
    });
  }
}

class MemoryOperation extends StatefulWidget {
  final MemoryOpera memoryOpera;
  final CalculatorCallbackDynamic callback;
  MemoryOperation(this.memoryOpera, this.callback);

  @override
  State<StatefulWidget> createState() {
    return new _MemoryOperation(memoryOpera,callback);
  }
}

class _MemoryOperation extends State<MemoryOperation> {
  MemoryOpera memoryOpera;
  final CalculatorCallbackDynamic callback;
  _MemoryOperation(this.memoryOpera, this.callback);

  String getDisplay() {
    if (memoryOpera == MemoryOpera.Clean) {
      return "MC";
    } else if (memoryOpera == MemoryOpera.Add) {
      return "MA";
    } else if (memoryOpera == MemoryOpera.Plus) {
      return "M+";
    } else if (memoryOpera == MemoryOpera.Minus) {
      return "M-";
    } else if (memoryOpera == MemoryOpera.Read) {
      return "MR";
    }
    return "MR";
  }

  void switchMAMC(MemoryOpera opera) {
    setState(() {
      if (opera == MemoryOpera.Add) {
        memoryOpera = MemoryOpera.Clean;
      } else if (opera == MemoryOpera.Clean) {
        memoryOpera = MemoryOpera.Add;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Container(
            height: buttonHeight,
            child: RaisedButton(
                key:Key(memoryOpera.toString()),
                child: new Text(getDisplay()),
                onPressed: () {
                  callback(memoryOpera);
                  switchMAMC(memoryOpera);
                })));
  }

}

class _CalInput extends StatelessWidget {
  final int input;
  final CalculatorCallbackInt callback;
  _CalInput(this.input, this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: buttonHeight,
        width: buttonWidth,
        child: RaisedButton(
            key:Key("input_$input"),
            child: new Text(
              this.input.toString(),
              style: getCalculateTextStyle(),
            ),
            onPressed: () {
              doInput();
            }));
  }

  bool doInput() {
    callback(this.input);
    return true;
  }
}

class _CalPercent extends StatelessWidget {
  final VoidCallback callback;
  _CalPercent(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: buttonHeight,
        width: buttonWidth,
        child: RaisedButton(
            key:Key(FormulaType.Percent.toString()),
            child: new Text(
              "%",
              style: getCalculateTextStyle(),
            ),
            onPressed: () {
              doInput();
            }));
  }

  bool doInput() {
    callback();
    return true;
  }
}

class _CalPoint extends StatelessWidget {
  final CalculatorCallback callback;
  _CalPoint(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: buttonHeight,
        width: buttonWidth,
        child: RaisedButton(
            key:Key("input_point"),
            child: new Text(
              ".",
              style: getCalculateTextStyle(),
            ),
            onPressed: () {
              doInput();
            }));
  }

  bool doInput() {
    callback(".");
    return true;
  }
}


class _MathOperation extends StatelessWidget {
  FormulaType mathOpera;
  final CalculatorCallbackDynamic callback;
  _MathOperation(this.mathOpera, this.callback);

  String getDisplay() {
    return Formula(mathOpera).symbol();
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Container(
            height: buttonHeight,
            child: RaisedButton(
                key:Key(mathOpera.toString()),
                child: new Text(
                  getDisplay(),
                  style: getCalculateTextStyle(),
                ),
                onPressed: () {
                  doMathOpera();
                })));
  }

  void doMathOpera() {
    callback(mathOpera);
  }
}

class _CleanOperation extends StatelessWidget {
  final VoidCallback callback;

  _CleanOperation(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Container(
            height: buttonHeight,
            child: RaisedButton(
                key:Key(FormulaAction.Clean.toString()),
                child: new Text(
                  "C",
                ),
                onPressed: () {
                  this.callback();
                })));
  }
}

class _DeleteOperation extends StatelessWidget {
  final VoidCallback callback;

  _DeleteOperation(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Container(
            height: buttonHeight,
            child: RaisedButton(
                key:Key(FormulaAction.Delete.toString()),
                child: new Text(
                  "Del",
                ),
                onPressed: () {
                  this.callback();
                })));
  }
}

class _CalculateOperation extends StatelessWidget {
  final VoidCallback callback;

  _CalculateOperation(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 1,
        child: Container(
            height: buttonHeight * 2,
            child: RaisedButton(
                key:Key(FormulaAction.Calculate.toString()),
                color: Colors.green[100],
                child: new Text(
                  "=",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  callback();
                })));
  }
}

TextStyle getCalculateTextStyle() {
  return TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
  );
}
