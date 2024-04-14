class ExpressionEvaluator {
  static num evaluate(String expression) {
    try {
      final tokens = _tokenize(expression);
      final postfix = _toPostfix(tokens);
      return _evaluatePostfix(postfix);
    } catch (e) {
      return double.nan;
    }
  }

  static List<String> _tokenize(String expression) {
    // Tokenize the expression, splitting by operators and parentheses
    // For simplicity, assume that the expression has proper formatting
    return expression.split(RegExp(r'\s+|(?=[()+*/-])|(?<=[()+*/-])'));
  }

  static List<String> _toPostfix(List<String> infix) {
    final output = <String>[];
    final operatorStack = <String>[];

    final precedence = {'+': 1, '-': 1, '*': 2, '/': 2};

    for (final token in infix) {
      if (num.tryParse(token) != null) {
        output.add(token); // If the token is a number, add it to the output
      } else if (token == '(') {
        operatorStack.add(
            token); // If it's an opening parenthesis, push it onto the stack
      } else if (token == ')') {
        // If it's a closing parenthesis, pop operators from the stack
        while (operatorStack.isNotEmpty && operatorStack.last != '(') {
          output.add(operatorStack.removeLast());
        }
        operatorStack.removeLast(); // Remove the '(' from the stack
      } else {
        // If it's an operator, pop operators from the stack until reaching an operator of lower precedence
        while (operatorStack.isNotEmpty &&
            precedence[operatorStack.last]! >= precedence[token]!) {
          output.add(operatorStack.removeLast());
        }
        operatorStack
            .add(token); // Then push the current operator onto the stack
      }
    }

    // Pop any remaining operators from the stack to the output
    while (operatorStack.isNotEmpty) {
      output.add(operatorStack.removeLast());
    }

    return output;
  }

  static num _evaluatePostfix(List<String> postfix) {
    final stack = <num>[];

    for (final token in postfix) {
      if (num.tryParse(token) != null) {
        stack.add(num.parse(token)); // If it's a number, push it onto the stack
      } else {
        // If it's an operator, pop operands from the stack, apply the operation, and push the result back
        final b = stack.removeLast();
        final a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
        }
      }
    }

    // The final result should be at the top of the stack
    return stack.single;
  }
}
