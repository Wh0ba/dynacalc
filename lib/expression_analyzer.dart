import 'package:math_expressions/math_expressions.dart';

class ExpressionAnalyzer {
  static final Parser _p = Parser();
  static num? analyzeAndEvaluate(
      String input, Function(String prefix) onPrefix) {
    num result = 0;
    final parenthesesexpressionRegex = RegExp(r'(\([^()]+\))');
    final expressionRegex = RegExp(
        r'(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\))(?:\s*[-+^\/*]\s*(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\)))*');
    final matchParentheses = parenthesesexpressionRegex.firstMatch(input);

    if (matchParentheses != null) {
      final expression = matchParentheses.group(0)!;
      final evaluated = _evaluateExpression(expression.substring(
          1, expression.length - 1)); // Remove the parentheses
      final replacedInput =
          input.replaceFirst(expression, evaluated.toString());
      return analyzeAndEvaluate(replacedInput,
          onPrefix); // Recursively analyze and evaluate the modified input
    } else {
      final matches = expressionRegex.allMatches(input).toList();
      if (matches.isEmpty) {
        return null;
      }
      if (matches.first.start > 0) {
        final prefix =
            input.substring(matches.first.start - 1, matches.first.start);
        if (prefix.contains(RegExp(r'(\$|\₺|\€|\£)'))) {
          onPrefix(prefix);
        }
      }
      if (matches.length == 2 &&
          input.contains(RegExp(r'for|in'), matches.first.end)) {
        final expression1 = matches.first.group(0)!;

        final expression2 = matches.last.group(0)!;
        final evaluated1 = _evaluateExpression(expression1);
        final evaluated2 = _evaluateExpression(expression2);
        if (evaluated1 != null && evaluated2 != null) {
          return evaluated1 * evaluated2;
        } else {
          return null;
        }
      }

      final expression = matches.first.group(0)!;
      final evaluated = _evaluateExpression(expression);
      if (evaluated != null) {
        result += evaluated;
      }

      return result;
    }
  }

  static num? _evaluateExpression(String expression) {
    try {
      Expression exp = _p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (_) {
      return null;
    }
  }
}
