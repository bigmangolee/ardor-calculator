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


import 'package:ardor_calculator/app/ardor/calculator/calculator_callback.dart';
import 'package:ardor_calculator/app/ardor/calculator/formula/formula.dart';
import 'package:ardor_calculator/app/ardor/calculator/formula/formula_standard.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/layout_notifier.dart';
import 'package:ardor_calculator/app/ardor/calculator/widget/toast.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:ardor_calculator/library/callback.dart';
import 'package:flutter/material.dart';

import 'package:ardor_calculator/app/ardor/calculator/cal_base.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


// ignore: must_be_immutable
class CalScientific extends CalBase {
  _CalScientificState __calScientificState;

  CalScientific(passwordInputCallback) : super(passwordInputCallback);

  @override
  String getName() {
    return S.current.calScientific_name;
  }

  @override
  IconData getIcon() {
    return Icons.directions_subway;
  }

  @override
  void reset() {
    __calScientificState.reset();
  }

  @override
  State<StatefulWidget> createState() {
    __calScientificState = _CalScientificState((String text) {
      onClickToTreasure(text);
    });
    return __calScientificState;
  }
}

class _CalScientificState extends State<CalScientific> {
  static final String _tag = "CalScientific";
  FormulaController _formulaController;

  ToolInfo _toolInfo = new ToolInfo();
  InputDisplay _inputInfo = new InputDisplay();
  OutDisplay _outputInfo = new OutDisplay();

  double displayW = 0;
  double itemW = 0;
  double itemH = 0;
  MemoryOperation _memoryOperationMAMC;
  StringCallback onClickToTreasure;

  _CalScientificState(this.onClickToTreasure) {
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

  void reset() {
    _toolInfo.onOpera("");
    _inputInfo.setText("");
    _outputInfo.setText("");
    _memoryOperationMAMC.setMemoryOperation(MemoryOpera.Add);
    _formulaController.input(FormulaAction.Clean);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = displayW == 0 ? size.width : displayW;
    itemW = width / 5;
    itemH = itemW * 0.6;
    return NotificationListener<LayoutChangedNotification>(
      onNotification: (notification) {
        /// 收到布局结束通知
        var size = context?.findRenderObject()?.paintBounds?.size;
        if (displayW == 0) {
          displayW = size.width;

          ///需要延迟刷新，否则会报错
          Future.delayed(Duration(milliseconds: 1), () {
            setState(() {});
          });
        }

        /// flutter1.7之后需要返回值,之前是不需要的.
        return null;
      },
      child: CustomSizeChangedLayoutNotifier(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _toolInfo,
                          _inputInfo,
                          _outputInfo,
                        ]),
                  )),
              new Container(
                width: width,
                height: itemH * 10,
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: new StaggeredGridView.countBuilder(
                  crossAxisCount: 5,
                  itemCount: 49,
                  itemBuilder: (BuildContext context, int index) =>
                  new Container(
                      child: new Center(
                        child: getKeyboard(index),
                      )),
                  staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(1, index == 44 ? 1.2 : 0.6),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> list;
  Widget getKeyboard(int index) {
    if (list != null) {
      return list[index];
    }
    //5x10
    list = new List();

    //row 1
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","函数","fuction"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","角度",""));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"e","e","e"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"π","π","π"));
    list.add(new _CleanOperation(() {
      onKey(FormulaAction.Clean);
    }));

    //row 2
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"MA","MA","MA"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"M+","M+","M+"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"M-","M-","M-"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"MR","MR","MR"));
    list.add(new _DeleteOperation(() {
      onKey(FormulaAction.Delete);
    }));

    //row 3
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"Log","Log","Log"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"√x","√x","√x"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"3√x","3√x","3√x"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"y√x","y√x","y√x"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"exp","exp","exp"));

    //row 4
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"lne","lne","lne"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"x2","x2","x2"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"x3","x3","x3"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"x^y","x^y","x^y"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"10^y","10^y","10^y"));

    //row 5
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"Log10","Log10","Log10"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"n!","n!","n!"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"1/x","1/x","1/x"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"mod","mod","mod"));
    list.add(new _MathOperation(Devi(), (dynamic key) {
      onKey(key);
    }));

    //row 6
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"atan2","atan2","atan2"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","+/-","+/-"));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"UpPriority","(",FormulaAction.UpPriority));
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"DownPriority",")",FormulaAction.DownPriority));
    list.add(new _MathOperation(Multi(), (dynamic key) {
      onKey(key);
    }));

    //row 7
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","sin","sin"));
    list.add(new _CalInput(7, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(8, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(9, (int key) {
      onKey(key);
    }));
    list.add(new _MathOperation(Minus(), (dynamic key) {
      onKey(key);
    }));

    //row 8
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","cos","cos"));
    list.add(new _CalInput(4, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(5, (int key) {
      onKey(key);
    }));
    list.add(new _CalInput(6, (int key) {
      onKey(key);
    }));
    list.add(new _MathOperation(Plus(), (dynamic key) {
      onKey(key);
    }));

    //row 9
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","tan","tan"));
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
      onClickToTreasure(_outputInfo.getText());
    }));

    //row 10
    list.add(new _CalAction((dynamic key) {
      onKey(key);
    },"","cot","cot"));
    list.add(new _CalPercent(() {
      onKey(Percent());
    }));
    list.add(new _CalInput(0, (int key) {
      onKey(key);
    }));
    list.add(new _CalPoint((String key) {
      onKey(key);
    }));


//    //row 1
//    list.add(_getMemoryOperationMAMC());
//    list.add(new MemoryOperation(MemoryOpera.Plus, (dynamic key) {
//      onKey(key);
//    }));
//    list.add(new MemoryOperation(MemoryOpera.Minus, (dynamic key) {
//      onKey(key);
//    }));
//    list.add(new MemoryOperation(MemoryOpera.Read, (dynamic key) {
//      onKey(key);
//    }));
//    //row 2
//    list.add(new _CleanOperation(() {
//      onKey(FormulaAction.Clean);
//    }));
//    list.add(new _MathOperation(Devi(), (dynamic key) {
//      onKey(key);
//    }));
//    list.add(new _MathOperation(Multi(), (dynamic key) {
//      onKey(key);
//    }));
//    list.add(new _DeleteOperation(() {
//      onKey(FormulaAction.Delete);
//    }));
//    //row 3
//    list.add(new _CalInput(7, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(8, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(9, (int key) {
//      onKey(key);
//    }));
//    list.add(new _MathOperation(Minus(), (dynamic key) {
//      onKey(key);
//    }));
//    //row 4
//    list.add(new _CalInput(4, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(5, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(6, (int key) {
//      onKey(key);
//    }));
//    list.add(new _MathOperation(Plus(), (dynamic key) {
//      onKey(key);
//    }));
//    //row 5
//    list.add(new _CalInput(1, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(2, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalInput(3, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalculateOperation(() {
//      onKey(FormulaAction.Calculate);
//      onClickToTreasure(_outputInfo.getText());
//    }));
//    //row 6
//    list.add(new _CalPercent(() {
//      onKey(Percent());
//    }));
//    list.add(new _CalInput(0, (int key) {
//      onKey(key);
//    }));
//    list.add(new _CalPoint((String key) {
//      onKey(key);
//    }));
    return list[index];
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
    ArdorToast.show(msg);
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
    return new Container(
      alignment: Alignment.topLeft,
      child: new Text(_info, key: Key('tool_info')),
    );
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
    return new Container(
      alignment: Alignment.topLeft,
      child: new Text(
        _info,
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w600,
        ),
        key: Key('input_display'),
      ),
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

  String getText() {
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
    return new Container(
      alignment: Alignment.bottomRight,
      child: new Text(
        _info,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
        ),
        key: Key('out_display'),
      ),
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
            key: Key(Percent().name()),
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
  Formula  formula;
  final CalculatorCallbackDynamic callback;
  _MathOperation(this.formula, this.callback);

  String getDisplay() {
    return formula.symbol();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(formula.toString()),
            child: new Text(
              getDisplay(),
              style: getCalculateTextStyle(),
            ),
            onPressed: () {
              doMathOpera();
            }));
  }

  void doMathOpera() {
    callback(formula);
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

/// 通用的功能按钮。
// ignore: must_be_immutable
class _CalAction extends StatelessWidget {
  final CalculatorCallbackDynamic callback;
  String id;
  String displayName;
  dynamic input;
  _CalAction(this.callback,this.id,this.displayName,this.input);

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        height: double.infinity,
        child: RaisedButton(
            key: Key(id),
            child: new Text(
              displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              doInput();
            }));
  }

  bool doInput() {
    callback(input);
    return true;
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
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
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
    fontSize: 25.0,
    fontWeight: FontWeight.w500,
  );
}