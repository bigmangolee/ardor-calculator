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

import 'package:ardor_calculator/app/ardor/calculator/calculator_callback.dart';
import 'package:ardor_calculator/generated/i18n.dart';
import 'package:ardor_calculator/library/applog.dart';
import 'package:ardor_calculator/library/stack.dart';

import 'package:ardor_calculator/app/ardor/calculator/formula/formula_standard.dart';
import 'package:decimal/decimal.dart';


/// Base of the natural logarithms.
///
/// Typically written as "e".
Decimal e =  Decimal.parse("2.718281828459045");

/// Natural logarithm of 10.
///
/// The natural logarithm of 10 is the number such that `pow(E, LN10) == 10`.
/// This value is not exact, but it is the closest representable double to the
/// exact mathematical value.
Decimal ln10 =  Decimal.parse("2.302585092994046");

/// Natural logarithm of 2.
///
/// The natural logarithm of 2 is the number such that `pow(E, LN2) == 2`.
/// This value is not exact, but it is the closest representable double to the
/// exact mathematical value.
Decimal ln2 =  Decimal.parse("0.6931471805599453");

/// Base-2 logarithm of [e].
Decimal log2e =  Decimal.parse("1.4426950408889634");

/// Base-10 logarithm of [e].
Decimal log10e =  Decimal.parse("0.4342944819032518");

/// The PI constant.
Decimal pi =  Decimal.parse("3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989");

/// Square root of 1/2.
Decimal sqrt1_2 =  Decimal.parse("0.7071067811865476");

/// Square root of 2.
Decimal sqrt2 =  Decimal.parse("1.4142135623730951");

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

/// 公式类
abstract class Formula {
  static var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  int getId();

  //公式名称。
  String name();

  //公式符号。
  String symbol();

  //公式计算优先级数值越高优先级越大，一般为1～9。
  int priority();

  Decimal operation();

  //参数值的数量
  int valueCount();

  void initValue();

  //增加参数
  bool addValue(Decimal v);

  //根据索引获取参数，index值为0-valueCount()之间,
  Decimal getValue(int index, Decimal def);

  //设置提升的优先权限
  void setPriorityAdd(int priorityAdd);

  //获取优先权限
  int getPriority();
}

abstract class FormulaBase implements Formula {
  List<Decimal> _valuesList = new List();
  int _priorityAdd = 0;
  static int _formulaid = 0;

  int _id = 0;

  FormulaBase() {
    _id = ++_formulaid;
  }

  int getId() {
    return _id;
  }

  int valueSize() {
    return _valuesList.length;
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
  void initValue(){
    _valuesList.clear();
  }

  @override
  Decimal getValue(int index, Decimal def) {
    if (_valuesList.length > index) {
      return _valuesList[index];
    }
    return def;
  }

  @override
  bool addValue(Decimal v) {
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
      onWarning(S.current?.formula_warning_can_not_input_null);
      return this;
    }
    AppLog.i(LogTag, "input:" + text.toString());
    if (text is FormulaAction) {
      _doFormulaAction(text);
    } else if (text is MemoryOpera) {
      _doMemoryOpera(text);
    } else if (text is Formula) {
      if (text is Minus) {
        //输入减号公式时，则有可能这两种可能需要转换为负数。
        dynamic last = _getFormulaLogic().lastLogic();
        if (last == null || "(" == last) {
          _doAddNegative();
        } else {
          _doAddFormula(text);
        }
      } else {
        _doAddFormula(text);
      }
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
      if (currentNumber == "") {
        this.onWarning(S.current?.formula_warning_nothing_to_memory_cache);
      } else {
        this.onTools(MemoryOpera.Add.toString());
        memoryCache = currentNumber;
      }
    } else if (MemoryOpera.Clean == action) {
      this.onTools(MemoryOpera.Clean.toString());
      memoryCache = "";
    } else if (MemoryOpera.Read == action) {
      this.onTools(MemoryOpera.Read.toString());
      if (memoryCache == "") {
        this.onWarning(S.current?.formula_warning_memory_cache_is_empty);
      } else {
        if ((memoryCache.contains(".") && currentNumber.contains(".")) ||
            (memoryCache.startsWith("-") && currentNumber != "")) {
          this.onWarning(
              S.current?.formula_warning_cannot_add_memoryCache_to_currentNumber(memoryCache, currentNumber));
        } else {
          cacheInput();
        }
      }
    } else if (MemoryOpera.Plus == action) {
      this.onTools(MemoryOpera.Plus.toString());
      if (memoryCache == "") {
        this.onWarning(S.current?.formula_warning_memory_cache_is_empty);
      } else {
        //新增减号公式
        Formula formula = Plus();
        _doAddFormula(formula);
        cacheInput();
      }
    } else if (MemoryOpera.Minus == action) {
      this.onTools(MemoryOpera.Minus.toString());
      if (memoryCache == "") {
        this.onWarning(S.current?.formula_warning_memory_cache_is_empty);
      } else {
        //新增减号公式
        Formula formula = Minus();
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
      onWarning(S.current?.formula_warning_not_a_legitimate_number);
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
  int _priorityWeight = 0;

  FormulaLogic(this._onWarning);

  void addFormula(Formula formula) {
    if (formula == null) {
      this._onWarning(S.current?.formula_warning_logic_illegal_formula_is_null);
      return;
    }
    formula.setPriorityAdd(_getPriority());
    if (_logicList.isEmpty) {
      _addFormula(formula);
      return;
    }

    if (_getCurrentNumber() == "") {
      //当前没有数字输入，则准备替换前一个公式
      dynamic d = _logicList[_logicList.length - 1];
      if (d == "(") {
        //提示警告，公式逻辑错误，公式之前不能是'('。
        this._onWarning(
            S.current?.formula_warning_logic_illegal_can_not_add_formula);
      } else if (d == ")") {
        //公式之前是')'，则可以添加公式
        _addFormula(formula);
      } else if (d is Formula){
        //是公式
        if (_isValuesFinish(d)) {
            //前面公式已完成参数填充，1个参数的公式
          _logicList.add(formula);
        } else {
          //替换
          _logicList[_logicList.length - 1] = formula;
        }
      }
    } else {
      _addFormula(formula);
    }
  }

  void _addFormula(Formula formula) {
    _logicList.add(formula);
    if (!_isValuesFinish(formula)) {
      //该公式参数不完整，则添加到未完成参数
      _unFinishFormula.push(formula);
    }
  }

  bool isEmpty() {
    return _logicList.isEmpty;
  }

  //获取最新的逻辑元素。
  dynamic lastLogic() {
    if (isEmpty()) {
      return null;
    } else {
      return _logicList.last;
    }
  }

  String _getCurrentNumber() {
    if (_logicList.length > 0) {
      dynamic d = _logicList[_logicList.length - 1];
      if (d == null) {
        return "";
      }else if (d == "(" || d == ")" || d is Formula) {
        return "";
      } else {
        //当前的数值
        return d.toString();
      }
    } else {
      return "";
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
    String _currentNumber = _getCurrentNumber();
    if (_currentNumber != "") {
      _currentNumber = _currentNumber.substring(0,_currentNumber.length-1);
      if (_currentNumber == "") {
        _logicList.removeLast();
      }
    } else {
      if (_logicList.length > 0) {
        _logicList.removeLast();
      } else {
        _onWarning(S.current?.formula_warning_nothing_can_be_deleted);
      }
    }
    AppLog.i(LogTag, "delete _logicList:"+_logicList.toString() + " _currentNumber:"+_currentNumber);
    if (_currentNumber != ""){
      setCurrentNumber(_currentNumber);
    }
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
      f.initValue();
      int index = logic.indexOf(f);
      List<int> removeIndes = new List();
      if (f.valueCount() == 1) {
        if (index > 0) {
          f.addValue(Decimal.parse(logic[index - 1]));
          removeIndes.add(index - 1);
        }
      } else {
        if (index > 0) {
          f.addValue(Decimal.parse(logic[index - 1]));
          removeIndes.add(index - 1);
        }
        for (int i = 1; i < f.valueCount(); i++) {
          if (index + i < logic.length) {
            f.addValue(Decimal.parse(logic[index + i]));
            removeIndes.add(index + i);
          }
        }
      }
      logic[index] = f.operation().toString();
      for (int j = removeIndes.length - 1; j >= 0; j--) {
        logic.removeAt(removeIndes[j]);
      }
    }
    return logic.isEmpty ? 0 : double.parse(logic[0]);
  }

  //设置当前数值。
  void setCurrentNumber(String value) {
    if (_logicList.length > 0) {
      dynamic d = _logicList[_logicList.length - 1];
      if (d == null || d == "(" || d == ")" || d is Formula) {
        _logicList.add(value);
      } else {
        //当前的数值
        _logicList[_logicList.length - 1] = value;
      }
    } else {
      _logicList.add(value);
    }
    if (!_unFinishFormula.isEmpty) {
      checkFinishFormula(_unFinishFormula.top);
    }
  }

  bool checkFinishFormula(Formula formula) {
    if (_isValuesFinish(formula)) {
      _unFinishFormula.pop();
      if (_unFinishFormula.isEmpty) {
        return true;
      } else {
        return checkFinishFormula(_unFinishFormula.top);
      }
    } else {
      return false;
    }
  }

  int _getPriority() {
    return _priorityWeight * 100;
  }

  //提升计算公式优先级，相当于输入(
  bool upPriorityWeight() {
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
        if (!_unFinishFormula.isEmpty && !_isValuesFinish(_unFinishFormula.top)) {
          _priorityWeight++;
          _logicList.add("(");
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  //降低计算公式优先级，相当于输入)
  bool downPriorityWeight() {
    if (_logicList.length == 0) {
      this._onWarning(S.current?.formula_warning_logic_illegal_can_not_be_brackets);
      return false;
    } else {
      dynamic d = _logicList[_logicList.length - 1];

      if (d is Formula) {
        if (_isValuesFinish(d)) {
          if (_priorityWeight > 0) {
            --_priorityWeight;
            _logicList.add(")");
            return true;
          } else {
            //不能匹配前括号(
            this._onWarning(S.current?.formula_warning_logic_illegal_can_not_match_brackets);
          }
        } else {
          //)前面不能是多参数的公式
          this._onWarning(S.current?.formula_warning_logic_illegal_can_not_be_brackets);
        }
      } else if (d == "(" || d == ")") {
        if (_priorityWeight > 0) {
          --_priorityWeight;
          _logicList.add(")");
          return true;
        } else {
          //不能匹配前括号(
          this._onWarning(S.current?.formula_warning_logic_illegal_can_not_match_brackets);
        }
      } else if (d is String) {
        if (_priorityWeight > 0) {
          --_priorityWeight;
          _logicList.add(")");
          return true;
        } else {
          //不能匹配前括号(
          this._onWarning(S.current?.formula_warning_logic_illegal_can_not_match_brackets);
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
    return format;
  }
}


