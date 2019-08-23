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
import 'package:anise_calculator/library/stack.dart';

import 'package:anise_calculator/app/anise/calculator/formula/formula_standard.dart';

typedef CalculatorCallback = void Function(String msg);
const String LogTag = "Formula";

enum FormulaAction {
  Clean,
  Delete,
  Calculate,
  UpPriority,
  DownPriority,
}

enum MemoryOpera {
  //缓存清除
  Clean,
  //缓存添加
  Add,
  //加上缓存
  Plus,
  //减去缓存
  Minus,
  //读取缓存
  Read,
}
//数学运算符。
enum FormulaType {
  //加
  Plus,
  //减
  Minus,
  //乘
  Multi,
  //除
  Devi,
  Percent,
  //平方
  Square,
  F3,
  F4,
  F5,
}

/// 公式类
abstract class Formula {
  static var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  factory Formula(FormulaType type) {
    if (type == FormulaType.Plus) {
      return Plus();
    } else if (type == FormulaType.Minus) {
      return Minus();
    } else if (type == FormulaType.Multi) {
      return Multi();
    } else if (type == FormulaType.Devi) {
      return Devi();
    } else if (type == FormulaType.Percent) {
      return Percent();
    } else if (type == FormulaType.Square) {
      return Square();
    } else if (type == FormulaType.F3) {
      return F3();
    } else if (type == FormulaType.F4) {
      return F4();
    } else if (type == FormulaType.F5) {
      return F5();
    }
    return null;
  }

  int getId();

  //公式名称。
  String name();

  //公式符号。
  String symbol();

  //公式计算优先级数值越高优先级越大，一般为1～9。
  int priority();

  double operation();

  //参数值的数量
  int valueCount();

  //增加参数
  bool addValue(double v);

  //根据索引获取参数，index值为0-valueCount()之间,
  double getValue(int index, double def);

  //设置提升的优先权限
  void setPriorityAdd(int priorityAdd);

  //获取优先权限
  int getPriority();
}

abstract class FormulaBase implements Formula {
  List<double> _valuesList = new List();
  int _priorityAdd = 0;
  static int _formulaid = 0;

  int _id = 0;

  FormulaBase() {
    _id = ++_formulaid;
  }

  int getId() {
    return _id;
  }

  @override
  void setPriorityAdd(int priorityAdd) {
    this._priorityAdd = priorityAdd;
  }

  @override
  int getPriority() {
    return priority() + this._priorityAdd;
  }

  @override
  double getValue(int index, double def) {
    if (_valuesList.length > index) {
      return _valuesList[index];
    }
    return def;
  }

  @override
  bool addValue(double v) {
    if (_valuesList.length < valueCount()) {
      _valuesList.add(v);
    }
    return _valuesList.length == valueCount();
  }

//  @override
//  String toString() {
//    String ret = x == null ? _getNumberDisplay(valueXDefault) : x.toString();
//    ret += " " + symbol() + " ";
//    ret +=
//        y == null ? (currentNumber == "" ? "?" : currentNumber) : y.toString();
//    return ret;
//  }

}

class FormulaController {
  CalculatorCallback onTools;
  CalculatorCallback onInputDisplay;
  CalculatorCallback onOutputDisplay;
  CalculatorCallback onWarning;

  FormulaController(
      this.onTools, this.onInputDisplay, this.onOutputDisplay, this.onWarning);

  FormulaLogic formulaLogic;
  String currentNumber = "";
  String memoryCache = "";

  FormulaController input(dynamic text) {
    if (text == null) {
      onWarning("can not input null");
      return this;
    }
    AppLog.i(LogTag, "input:" + text.toString());
    if (text is FormulaAction) {
      _doFormulaAction(text);
    } else if (text is MemoryOpera) {
      _doMemoryOpera(text);
    } else if (text is FormulaType) {
      _doAddFormula(Formula(text));
    } else if (text is int) {
      _doAddNumber(text);
    } else if ("." == text) {
      _doAddDecimal(text);
    } else if ("-" == text) {
      _doAddNegative();
    }
    _doInputDisplay();
    return this;
  }

  FormulaLogic _getFormulaLogic() {
    if (formulaLogic == null) {
      formulaLogic = new FormulaLogic(this.onWarning);
    }
    return formulaLogic;
  }
  
  void _doFormulaAction(FormulaAction action) {
    if (FormulaAction.Clean == action) {
      _doClean();
    } else if (FormulaAction.Delete == action) {
      _doDelete();
    } else if (FormulaAction.Calculate== action) {
      _doCalculate();
    } else if (FormulaAction.UpPriority== action) {
      _getFormulaLogic().upPriorityWeight();
    } else if (FormulaAction.DownPriority== action) {
      _getFormulaLogic().downPriorityWeight();
    }
  }

  void _doClean() {
    formulaLogic = new FormulaLogic(this.onWarning);
    currentNumber = "";
    onInputDisplay("");
    onOutputDisplay("");
  }

  void _doDelete() {
    currentNumber = _getFormulaLogic().delete();
  }

  void _doCalculate() {
    if (formulaLogic != null) {
      formulaLogic.finishNumberInput();
      double out = formulaLogic.calculate();
      onOutputDisplay(getNumberDisplay(out));
    }
  }

  String getNumberDisplay(double number) {
    String s = number.toString();
    if (s.endsWith(".0")) {
      return s.substring(0, s.length - 2);
    } else {
      return s;
    }
  }

  void _doMemoryOpera(action) {
    Function cacheInput = () {
      for (int i = 0; i < memoryCache.length; i++) {
        String t = memoryCache.substring(i, i + 1);
        if (t == "-") {
          this.input(t);
        } else {
          this.input(int.parse(t));
        }
      }
    };

    if (MemoryOpera.Add == action) {
      this.onTools(MemoryOpera.Add.toString());
      memoryCache = currentNumber;
    } else if (MemoryOpera.Clean == action) {
      this.onTools(MemoryOpera.Clean.toString());
      memoryCache = "";
    } else if (MemoryOpera.Read == action) {
      this.onTools(MemoryOpera.Read.toString());
      if (memoryCache == "") {
        this.onWarning("Memory cache is empty.");
      } else {
        if ((memoryCache.contains(".") && currentNumber.contains(".")) ||
            (memoryCache.startsWith("-") && currentNumber != "")) {
          this.onWarning(
              "Cannot add $memoryCache to the end of $currentNumber.");
        } else {
          cacheInput();
        }
      }
    } else if (MemoryOpera.Plus == action) {
      this.onTools(MemoryOpera.Plus.toString());
      if (memoryCache == "") {
        this.onWarning("Memory cache is empty.");
      } else {
        //新增减号公式
        Formula formula = Formula(FormulaType.Plus);
        _doAddFormula(formula);
        cacheInput();
      }
    } else if (MemoryOpera.Minus == action) {
      this.onTools(MemoryOpera.Minus.toString());
      if (memoryCache == "") {
        this.onWarning("Memory cache is empty.");
      } else {
        //新增减号公式
        Formula formula = Formula(FormulaType.Minus);
        _doAddFormula(formula);
        cacheInput();
      }
    }

  }

  void _doAddFormula(Formula formula) {
    _getFormulaLogic().addFormula(formula);
    currentNumber = "";
  }

  void _doAddNumber(int n) {
    String t = n.toString();
    currentNumber += t;
    _getFormulaLogic().setCurrentNumber(currentNumber);
  }

  void _doAddDecimal(String text) {
    if (currentNumber.contains(".")) {
      //已经包含小数点，不能重复添加，错误提示回调
      onWarning("非数字！");
    } else {
      if (currentNumber == "") {
        currentNumber = "0";
      }
      currentNumber += text;
      _getFormulaLogic().setCurrentNumber(currentNumber);
    }
  }

  //添加负号
  void _doAddNegative() {
    if (currentNumber == "") {
      currentNumber = "-";
    } else if (Formula.numbers.contains(currentNumber.substring(0, 1))) {
      //首字符是数字
      currentNumber = "-" + currentNumber;
    } else if (currentNumber.startsWith("-")) {
      //当前已经是负数，再添加负数，则负负得正，应该取消负数。
      currentNumber = currentNumber.substring(1);
    }
    _getFormulaLogic().setCurrentNumber(currentNumber);
  }

  void _doInputDisplay() {
    onInputDisplay(_getFormulaLogic().toString());
  }
}

//公式逻辑运算类。
class FormulaLogic {
  CalculatorCallback _onWarning;

  //只能存储数字,Formula,(,)四种类型
  List<dynamic> _logicList = new List();
  //未完成参数填充的公式。
  Stack<Formula> _unFinishFormula = Stack();
  Formula _currentFormula;
  String _currentNumber = "";
  int _priorityWeight = 0;

  FormulaLogic(this._onWarning);

  void addFormula(Formula formula) {
    if (formula == null) {
      this._onWarning("Formula logic illegal: formula is null");
      return;
    }
    formula.setPriorityAdd(_getPriority());
    if (_logicList.isEmpty) {
      _addNumber();
      _addFormula(formula);
      return;
    }

    if (_currentNumber == "") {
      //当前没有数字输入，则准备替换前一个公式
      dynamic d = _logicList[_logicList.length - 1];
      if (d == "(") {
        //提示警告，公式逻辑错误，公式之前不能是'('。
        this._onWarning(
            "Formula logic illegal: can't add formula. error code: 1");
      } else if (d == ")") {
        //公式之前是')'，则可以添加公式
        _addFormula(formula);
      } else if (d is String) {
        //前一个符号是数值，则替换
        if (_currentFormula == null) {
          //首次输入时，前面已经输入数值，则将公式添加进来
          _addFormula(formula);
        } else {
          if (_isValuesFinish(_currentFormula)) {
            //前面公式已完成参数填充，则将当前公式添加到末尾
            _addFormula(formula);
          } else {
            //前面公式未完成填充，且没有数值输入，则不能直接添加公式
            this._onWarning(
                "Formula logic illegal: can't add formula. error code: 2");
          }
        }
      } else if (d is Formula) {
        //前一个符号是公式，则替换
        if (_isValuesFinish(_currentFormula)) {
          //前面公式已完成参数填充，则将当前公式添加到末尾
          _addFormula(formula);
        } else {
          //前面公式未完成填充，且还未有任何数值输入，则不能直接替换公式
          _logicList[_logicList.length - 1] = formula;
          _currentFormula = formula;
        }
      } else {
        this._onWarning(
            "Formula logic illegal: can't add formula. error code: 3");
      }
    } else {
      //有缓存的数值待输入
      if (_currentFormula == null) {
        _addNumber();
        _addFormula(formula);
      } else {
        if (_isValuesFinish(_currentFormula)) {
          //前一个公式参数完整，且当前有缓存的数值，若需要直接增加新公式时，则不允许
          this._onWarning(
              "Formula logic illegal: can't add formula. error code: 4");
        } else {
          _addNumber();
          if (_isValuesFinish(_currentFormula)) {
            // 先添加参数后，判断前一个公式参数完整，则可以新增公式
            _addFormula(formula);
          } else {
            // 给前一个公式添加缓存的参数后，仍然未满足其所有参数需要，
            // 则还不能直接添加公式，需要等待数值输入完整后才能新增公式
            if (formula.getPriority() > _currentFormula.getPriority()) {
              // 后面的公式优先权限比前一个公式优先权限大
              // 则允许先将后面的公式添加进来，先填充完优先级大的公式参数后，
              // 再依次填满之前保存未完成参数的公式填充
              _unFinishFormula.push(_currentFormula);
              _addFormula(formula);
            } else {
              this._onWarning(
                  "Formula logic illegal: can't add formula. error code: 5");
            }
          }
        }
      }
    }
  }

  void _addFormula(Formula formula) {
    _logicList.add(formula);
    _currentFormula = formula;
  }

  void _addNumber() {
    _logicList.add(_currentNumber);
    _currentNumber = "";
    if (_currentFormula != null && _isValuesFinish(_currentFormula)) {
      Formula formula = _unFinishFormula.pop();
      if (formula != null) {
        _currentFormula = formula;
      }
    }
  }

  //判断一个公式参数是否完整。
  bool _isValuesFinish(Formula formula) {
    if (formula.valueCount() <= 1) {
      return true;
    }

    int index = _logicList.indexOf(formula);
    int priority = 0;
    int count = 1;
    for (int i = index + 1; i < _logicList.length; i++) {
      dynamic d = _logicList[i];
      if (d == "(") {
        priority++;
        continue;
      } else if (d == ")") {
        priority--;
        if (priority == 0) {
          //有效参数
          count++;
        } else {
          //无效参数
        }
        continue;
      } else if (d is String) {
        //数值
        if (priority == 0) {
          //有效参数
          count++;
        } else {
          //无效参数
        }
      } else if (d is Formula) {
        //公式
        if (priority > 0) {
          //嵌套公式，需要循环判官改公式是否完整
          if (_isValuesFinish(d)) {
            //嵌套公式已完整，则等待)
          } else {
            //嵌套公式也还未完成参数填充。
            return false;
          }
        } else {
          // 已无嵌套公式，则中断继续往下查找参数
          // 判断该公式的参数数量是否完整
          break;
        }
      }
    }
    return count == formula.valueCount();
  }

  String delete() {
    Function findLastFormula = () {
      bool flagHasFormula = false;
      for (int i=_logicList.length-1;i>0;i--) {
        dynamic dd = _logicList[i];
        if (dd is Formula) {
          _currentFormula = dd;
          flagHasFormula = true;
          break;
        }
      }
      if (!flagHasFormula) {
        _currentFormula = null;
      }
    };

    if (_currentNumber != "") {
      _currentNumber = _currentNumber.substring(0,_currentNumber.length-1);
    } else {
      if (_logicList.length > 0) {
        dynamic d = _logicList[_logicList.length - 1];
        //Formula,(,)
        _logicList.removeLast();
        if (d == "(" || d == ")" ) {
          //属于这2种类型时，则直接移除掉就好
        } else if (d is Formula) {

        } else {
          //是数值时，则将该数值赋值给当前编辑的数值，逐个位数移除
          String n = d;
          if (n != null && n != ""){
            _currentNumber = n.substring(0,n.length-1);
          }
        }
        //删除时，需要寻找前面是否还有公式，
        // 若有，则将其取出赋值给当前编辑的公式，若没有找到公式，则当前编辑的公式要赋值空
        findLastFormula();
      } else {
        _onWarning("");
      }
    }
    AppLog.i(LogTag, "delete _logicList:"+_logicList.toString() + " _currentNumber:"+_currentNumber);
    return _currentNumber;
  }

  double calculate() {
    //复制一份公式逻辑列表
    List<dynamic> logic = List.from(_logicList);
    //公式列表，用于排列公式优先级
    List<Formula> formulaList = new List();
    //过滤()算数权重字符
    logic.removeWhere((dynamic d) {
      return d == "(" || d == ")";
    });

    //提炼公式
    for (int i = 0; i < logic.length; i++) {
      dynamic d = logic[i];
      if (d is Formula) {
        formulaList.add(d);
      }
    }

    //排序公式优先级
    formulaList.sort((left, right) {
      if (left.getPriority() == right.getPriority()) {
        //优先级相等的两个公式，比较ID生成顺序。
        return left.getId() > right.getId() ? 1 : -1;
      } else {
        //优先级高到低排序
        return left.getPriority() < right.getPriority() ? 1 : -1;
      }
    });

    //遍历公式列表，逐个计算出结果。
    for (int i = 0; i < formulaList.length; i++) {
      Formula f = formulaList[i];
      int index = logic.indexOf(f);
      List<int> removeIndes = new List();
      if (f.valueCount() == 1) {
        if (index > 0) {
          f.addValue(double.parse(logic[index - 1]));
          removeIndes.add(index - 1);
        }
      } else {
        if (index > 0) {
          f.addValue(double.parse(logic[index - 1]));
          removeIndes.add(index - 1);
        }
        for (int i = 1; i < f.valueCount(); i++) {
          if (index + i < logic.length) {
            f.addValue(double.parse(logic[index + i]));
            removeIndes.add(index + i);
          }
        }
      }
      logic[index] = f.operation().toString();
      for (int j = removeIndes.length - 1; j >= 0; j--) {
        logic.removeAt(removeIndes[j]);
      }
    }
    return double.parse(logic[0]);
  }

  //设置当前数值。
  void setCurrentNumber(String value) {
    _currentNumber = value;
  }

  //完成当前参数数值输入。
  void finishNumberInput() {
    if (_currentNumber != "") {
      if (_currentFormula == null) {
        _addNumber();
      } else {
        if (_isValuesFinish(_currentFormula)) {
          //当前公式已经完成所有参数接收，已经没有参数输入位置，则不能输入
          this._onWarning(
              "Formula logic illegal: can't add formula. error code: 6");
        } else {
          _addNumber();
        }
      }
    }
    _currentNumber = "";
  }

  int _getPriority() {
    return _priorityWeight * 100;
  }

  //提升计算公式优先级，相当于输入(
  bool upPriorityWeight() {
    if (_currentNumber != "") {
      _addNumber();
    }
    if (_logicList.length == 0) {
      _priorityWeight++;
      _logicList.add("(");
      return true;
    } else {
      dynamic d = _logicList[_logicList.length - 1];
      if (d == "(" || d is Formula) {
        _priorityWeight++;
        _logicList.add("(");
        return true;
      } else if (d == ")" || d is String) {
        //可能是当前函数参数未填充完所有参数
        if (_currentFormula != null && !_isValuesFinish(_currentFormula)) {
          _priorityWeight++;
          _logicList.add("(");
          return true;
        } else {
          return false;
        }
      }
    }
  }

  //降低计算公式优先级，相当于输入)
  bool downPriorityWeight() {
    if (_logicList.length == 0) {
      this._onWarning("Formula logic illegal: It can't be )");
      return false;
    } else {
      dynamic d = _logicList[_logicList.length - 1];
      if (_currentNumber == "") {
        if (d is Formula) {
          if (d.valueCount() <= 1) {
            //单个参数的公式可以允许降级括号
            if (_priorityWeight > 0) {
              --_priorityWeight;
              _logicList.add(")");
              return true;
            } else {
              //不能匹配前括号(
              this._onWarning("Formula logic illegal: Can't match (");
            }
          } else {
            //)前面不能是多参数的公式
            this._onWarning("Formula logic illegal: It can't be )");
          }
        } else {
          //d是数字、(、)
          if (_priorityWeight > 0) {
            --_priorityWeight;
            _logicList.add(")");
            return true;
          } else {
            //不能匹配前括号(
            this._onWarning("Formula logic illegal: Can't match (");
          }
        }
      } else {
        if (d is Formula) {
          if (d.valueCount() <= 1) {
            //单个参数的公式，且有当前输入的数字，
            this._onWarning("Formula logic illegal: 2");
          } else {
            //多参数的公式
            if (_priorityWeight > 0) {
              --_priorityWeight;
              _addNumber();
              _logicList.add(")");
              return true;
            } else {
              //不能匹配前括号(
              this._onWarning("Formula logic illegal: Can't match (");
            }
          }
        } else {
          //d是数字、(、)
          if (_priorityWeight > 0) {
            --_priorityWeight;
            _addNumber();
            _logicList.add(")");
            return true;
          } else {
            //不能匹配前括号(
            this._onWarning("Formula logic illegal: Can't match (");
          }
        }
      }
    }
    return false;
  }

  @override
  String toString() {
    String format = "";
    for (int i = 0; i < _logicList.length; i++) {
      dynamic d = _logicList[i];
      if (d is Formula) {
        format += "" + d.symbol() + "";
      } else {
        format += "" + d.toString() + "";
      }
    }
    if (_currentNumber != "") {
      format += _currentNumber;
    }
    return format;
  }
}


