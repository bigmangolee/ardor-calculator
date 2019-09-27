// Copyright 2019-present the ardor.App authors. All Rights Reserved.
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

import 'package:ardor_calculator/library/applog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
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

  MemoryOperation _memoryOperationMAMC;
  BuildContext _context;
  CalGeneral() {
    _formulaController = new FormulaController(
      (String msg) {
        onTools(msg);
      },
      (String msg) {
        onInputDisplay(msg);
      },
      (String msg) {
        onOutputDisplay(msg);
      },
      (String msg) {
        onWarning(msg);
      },
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
    _context = context;
    return new Center(
      child: new Column(
//        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: Container(
                child: new Column(children: <Widget>[
                  _toolInfo,
                  _inputInfo,
                  _outputInfo,
                ]),
              )),
          new Container(
            alignment: Alignment.bottomCenter,
            height: 300,
            padding:const EdgeInsets.all(1.0),
            child: new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: 23,
              itemBuilder: (BuildContext context, int index) => new Container(
                  child: new Center(
                child: getKeyboard(index),
              )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(1, index == 19 ? 1.2 : 0.6),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> list;
  Widget getKeyboard(int index) {
    if (list != null) {
      return list[index];
    }

    list = new List();

    //row 1
    list.add(_getMemoryOperationMAMC());
    list.add(new MemoryOperation(MemoryOpera.Plus, (dynamic key) {
      onKey(key);
    }));
    list.add(new MemoryOperation(MemoryOpera.Minus, (dynamic key) {
      onKey(key);
    }));
    list.add(new MemoryOperation(MemoryOpera.Read, (dynamic key) {
      onKey(key);
    }));
    //row 2
    list.add(new _CleanOperation(() {
      onKey(FormulaAction.Clean);
    }));
    list.add(new _MathOperation(FormulaType.Devi, (dynamic key) {
      onKey(key);
    }));
    list.add(new _MathOperation(FormulaType.Multi, (dynamic key) {
      onKey(key);
    }));
    list.add(new _DeleteOperation(() {
      onKey(FormulaAction.Delete);
    }));
    //row 3
    list.add(new _CalInput(7, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(8, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(9, (int key) {
      onKey(key);
    }));
    list.add(new _MathOperation(FormulaType.Minus, (dynamic key) {
      onKey(key);
    }));
    //row 4
    list.add(new _CalInput(4, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(5, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(6, (int key) {
      onKey(key);
    }));
    list.add(new _MathOperation(FormulaType.Plus, (dynamic key) {
      onKey(key);
    }));
    //row 5
    list.add(new _CalInput(1, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(2, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(3, (int key) {
      onKey(key);
    }));
    list.add(new _CalculateOperation(() {
      onKey(FormulaAction.Calculate);
      onClickCalculate();
    }));
    //row 6
    list.add(new _CalPercent(() {
      onKey(FormulaType.Percent);
    }));
    list.add(new _CalInput(0, (int key) {
      onKey(key);
    }));
    list.add(new _CalPoint((String key) {
      onKey(key);
    }));
    return list[index];
  }

  int _onClickTimes = 0;
  int _lastClickTime = 0;
  void onClickCalculate() {
    int newLastClickTime = new DateTime.now().millisecondsSinceEpoch;
    if (newLastClickTime - _lastClickTime < 500) {
      //有效连续点击
      if(++_onClickTimes >= 4){
        //连续点击4次，则出发跳转
        startTreasure(_context,_outputInfo.getText()).then((bool onValue){
          if (!onValue){
            //密码校验失败
            showToast("校验失败");
          }
        });
      }
    } else {
      _onClickTimes = 0;
    }
    _lastClickTime = newLastClickTime;
  }

  MemoryOperation _getMemoryOperationMAMC() {
    if (_memoryOperationMAMC == null) {
      _memoryOperationMAMC =
          new MemoryOperation(MemoryOpera.Add, (dynamic key) {
        onKey(key);
      });
    }
    return _memoryOperationMAMC;
  }

  void onKey(dynamic key) {
    _formulaController.input(key);
    AppLog.d(_tag, key.toString());
  }

  void onTools(String msg) {
    if (msg == MemoryOpera.Add.toString()) {
      _toolInfo.onOpera("M");
      _memoryOperationMAMC.setMemoryOperation(MemoryOpera.Clean);
    } else if (msg == MemoryOpera.Clean.toString()) {
      _toolInfo.onOpera("");
      _memoryOperationMAMC.setMemoryOperation(MemoryOpera.Add);
    }
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
      backgroundColor: Colors.lime[100],
      textColor: Colors.deepOrange,
    );
  }
}

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
    return new Text(_info, key: Key('tool_info'));
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
      key: Key('input_display'),
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

  String _content;
  void setText(String content) {
    _content = content;
    __outDisplay.setTextInfo(content);
  }

  String getText(){
    return _content;
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
      key: Key('out_display'),
    );
  }

  void setTextInfo(String info) {
    setState(() {
      _info = info;
    });
  }
}

// ignore: must_be_immutable
class MemoryOperation extends StatefulWidget {
  MemoryOpera memoryOpera;
  final CalculatorCallbackDynamic callback;
  _MemoryOperation _memoryOperation;
  MemoryOperation(this.memoryOpera, this.callback);

  void setMemoryOperation(MemoryOpera memoryOpera) {
    this.memoryOpera = memoryOpera;
    _memoryOperation.setMemoryOperation(memoryOpera);
  }

  @override
  State<StatefulWidget> createState() {
    _memoryOperation = new _MemoryOperation(memoryOpera, callback);
    return _memoryOperation;
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

  void setMemoryOperation(MemoryOpera memoryOpera) {
    setState(() {
      this.memoryOpera = memoryOpera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(memoryOpera.toString()),
            child: new Text(getDisplay()),
            onPressed: () {
              callback(memoryOpera);
            }));
  }
}

class _CalInput extends StatelessWidget {
  final int input;
  final CalculatorCallbackInt callback;
  _CalInput(this.input, this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      child: RaisedButton(
          key: Key("input_$input"),
          child: new Text(
            this.input.toString(),
            style: getCalculateTextStyle(),
          ),
          onPressed: () {
            doInput();
          }),
    );
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
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(FormulaType.Percent.toString()),
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
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key("input_point"),
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
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(mathOpera.toString()),
            child: new Text(
              getDisplay(),
              style: getCalculateTextStyle(),
            ),
            onPressed: () {
              doMathOpera();
            }));
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
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(FormulaAction.Clean.toString()),
            child: new Text(
              "C",
            ),
            onPressed: () {
              this.callback();
            }));
  }
}

class _DeleteOperation extends StatelessWidget {
  final VoidCallback callback;

  _DeleteOperation(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(FormulaAction.Delete.toString()),
            child: new Text(
              "Del",
            ),
            onPressed: () {
              this.callback();
            }));
  }
}

class _CalculateOperation extends StatelessWidget {
  final VoidCallback callback;

  _CalculateOperation(this.callback);

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(FormulaAction.Calculate.toString()),
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
            },

            ));
  }
}

TextStyle getCalculateTextStyle() {
  return TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
  );
}
