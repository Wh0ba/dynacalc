import 'package:dynacalc/expression_cleaner.dart';
import 'package:math_expressions/math_expressions.dart';

class ExpressionAnalyzer {
  static final Parser _p = Parser();
  static final secondExpressionPrecentageRegex =
      RegExp(r'(?<=[+\-*\/])\s*\d+\%');
  static final parenthesesexpressionRegex = RegExp(r'(\([^()]+\))');
  static final expressionRegex = RegExp(
      r'(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\))(?:\s*[-+^\/*]\s*(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\)))*');

  static num? analyzeAndEvaluate(
      String input, Function(String prefix) onPrefix) {
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
      if (matches.first.end < input.length) {
        final secondExpression =
            secondExpressionPrecentageRegex.firstMatch(input);
        if (secondExpression != null) {
          
          final secondExp =
              input.substring(secondExpression.start, secondExpression.end - 1);
          final firstExp =
              input.substring(matches.first.start, secondExpression.start - 1);
          try {
            final firstNum = num.parse(firstExp);
            final secondNum = num.parse(secondExp);
            final result = num.parse(((firstNum / 100) * secondNum).toStringAsFixed(2));
            
            String replacedMatch = matches.first.group(0)!.replaceRange(
                matches.first.group(0)!.indexOf(RegExp(r'([-+^\/*])')) + 1, null, result.toString());
            final evaluated = _evaluateExpression(replacedMatch);
            if (evaluated != null) {
              return evaluated;
            } else {
              return null;
            }
          } catch (_) {
            return null;
          }
        }
      }
      if (matches.length == 2) {
        final expression = ExpressionCleaner.removeNonMathematicalTerms(input);
        final evaluated1 = _evaluateExpression(expression);
        if (evaluated1 != null) {
          return evaluated1;
        } else {
          return null;
        }
      }

      final expression = matches.first.group(0)!;
      final evaluated = _evaluateExpression(expression);
      if (evaluated != null) {
        return evaluated;
      } else {
        return null;
      }
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
