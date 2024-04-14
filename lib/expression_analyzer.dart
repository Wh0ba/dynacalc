import 'package:dynacalc/expression_evaluator.dart';

class ExpressionAnalyzer {
  static num? analyzeAndEvaluate(String input) {
    final expressionRegex = RegExp(r'(\([^()]+\))');
    final match = expressionRegex.firstMatch(input);

    if (match != null) {
      final expression = match.group(0)!;
      final evaluated = _evaluateExpression(expression.substring(1, expression.length - 1)); // Remove the parentheses
      final replacedInput = input.replaceFirst(expression, evaluated.toString());
      return analyzeAndEvaluate(replacedInput); // Recursively analyze and evaluate the modified input
    } else {
      return _evaluateExpression(input); // No more parentheses, evaluate the remaining expression
    }
  }

  static num _evaluateExpression(String expression) {
    try {
      return ExpressionEvaluator.evaluate(expression);
    } catch (_) {
      return double.nan;
    }
  }
}

