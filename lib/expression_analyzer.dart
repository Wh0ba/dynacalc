import 'package:dynacalc/expression_cleaner.dart';
import 'package:math_expressions/math_expressions.dart';

class ExpressionAnalyzer {
  static final Parser _parser = Parser();
  static final RegExp _percentageRegex = RegExp(r'(?<=[+\-*\/])\s*\d+\%');
  static final RegExp _parenthesesRegex = RegExp(r'(\([^()]+\))');
  static final RegExp _expressionRegex = RegExp(
      r'(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\))(?:\s*[-+^\/*]\s*(?:\d+|\(\d+\s*[-+^\/*]\s*\d+\)))*');

  static num? analyzeAndEvaluate(
      String input, Function(String prefix) onPrefix) {
    final matchParentheses = _parenthesesRegex.firstMatch(input);

    if (matchParentheses != null) {
      final expression = matchParentheses.group(0)!;
      final evaluated =
          _evaluateExpression(expression.substring(1, expression.length - 1));
      final replacedInput =
          input.replaceFirst(expression, evaluated.toString());
      return analyzeAndEvaluate(replacedInput, onPrefix);
    } else {
      final matches = _expressionRegex.allMatches(input).toList();
      if (matches.isEmpty) {
        return null;
      }

      _handlePrefix(input, matches.first, onPrefix);
      input = input.replaceAll(RegExp(r'(\$|\₺|\€|\£)'), '');
      if (matches.first.end < input.length) {
        final secondExpression = _percentageRegex.firstMatch(input);
        if (secondExpression != null) {
          final result = _evaluatePercentageExpression(
              input, matches.first, secondExpression);
          return result;
        }
      }

      if (matches.length >= 2) {
        final percentageIndex = input.indexOf('%');
        if (percentageIndex != -1 && percentageIndex < matches.first.end + 1) {
          final n1 =
              num.parse(input.substring(matches.first.start, percentageIndex));
          final n2 = num.parse(matches[1].group(0)!);
          final result = (n1 / 100) * n2;
          return result;
        }
        final forIndex = input.indexOf('for');
        if (forIndex != -1 &&
            forIndex > matches.first.start &&
            forIndex < matches[1].end) {
          input = input.replaceFirst('for', '*', forIndex);
          final result = analyzeAndEvaluate(input, onPrefix);
          return result;
        }
        final expression = ExpressionCleaner.removeNonMathematicalTerms(input.substring(matches.first.start, matches.first.end));
        final evaluated = _evaluateExpression(expression);
        return evaluated;
      }

      final expression = matches.first.group(0)!;
      final evaluated = _evaluateExpression(expression);
      return evaluated;
    }
  }

  static void _handlePrefix(
      String input, RegExpMatch match, Function(String prefix) onPrefix) {
    if (match.start > 0) {
      final prefix = input.substring(match.start - 1, match.start);
      if (prefix.contains(RegExp(r'(\$|\₺|\€|\£)'))) {
        onPrefix(prefix);
      }
    }
  }

  static num? _evaluatePercentageExpression(
      String input, RegExpMatch firstMatch, RegExpMatch secondMatch) {
    final secondExp = input.substring(secondMatch.start, secondMatch.end - 1);
    final firstExp = input.substring(firstMatch.start, secondMatch.start - 1);
    try {
      final firstNum = num.parse(firstExp);
      final secondNum = num.parse(secondExp);
      final result =
          num.parse(((firstNum / 100) * secondNum).toStringAsFixed(2));

      final replacedMatch = firstMatch.group(0)!.replaceRange(
          firstMatch.group(0)!.indexOf(RegExp(r'([-+^\/*])')) + 1,
          null,
          result.toString());
      final evaluated = _evaluateExpression(replacedMatch);
      return evaluated;
    } catch (_) {
      return null;
    }
  }

  static num? _evaluateExpression(String expression) {
    try {
      final exp = _parser.parse(expression);
      final cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (_) {
      return null;
    }
  }
}
