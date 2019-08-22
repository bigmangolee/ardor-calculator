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


class Stack<E> {
  final List<E> _stack;
  int _top;

  Stack()
      : _top = -1,
        _stack = List<E>();

  bool get isEmpty => _top == -1;
  int get size => _top + 1;

  void push(E e) {
    ++_top;
    if (_stack.length > _top ) {
      _stack[_top] = e;
    } else {
      _stack.add(e);
    }
  }

  E pop() {
    return isEmpty ? null : _stack[_top--];
  }

  E get top {
    return isEmpty ? null : _stack[_top];
  }

  E getElement(int index) {
    if (isEmpty || index >= size) {
      return null;
    }
    return _stack[index];
  }
}

void main() {
  var stack = Stack<int>();
  for (var i = 0; i < 10; i++) stack.push(i * i);
  print(stack.top);

  var sbuff = StringBuffer();
  while (!stack.isEmpty) sbuff.write('${stack.pop()} ');
  print(sbuff.toString());
}