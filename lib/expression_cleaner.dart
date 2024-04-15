class ExpressionCleaner {
  static String removeNonMathematicalTerms(String input) {
    final tokens = input.split(' ');
    final mathematicalTokens = _filterMathematicalTerms(tokens);
    return mathematicalTokens.join(' ');
  }



  static List<String> _filterMathematicalTerms(List<String> tokens) {
    final mathematicalTokens = <String>[];
    final operators = {'+', '-', '*', '/', '(', ')'};

    for (final token in tokens) {
      if (num.tryParse(token) != null || operators.contains(token)) {
        mathematicalTokens.add(token);
      }
    }

    return mathematicalTokens;
  }
}