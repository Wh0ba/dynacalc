import 'package:dynacalc/tokenizer.dart';

class WordEngine {
  // This will store the encountered numbers as the index and the value of the number to prevent repeated numbers on each processing step
  final Map<String, num> numbers = {};
  void processString(String input) {
    final tokens = Tokenizer.tokenize(input);
    for (final (lineIndex, tokenLine) in tokens.indexed) {
      for (final (i, token) in tokenLine.indexed) {
        num? n = int.tryParse(token);
        if (n != null) {
          numbers['$lineIndex:$i'] = n;
        } else {
          numbers.remove('$lineIndex:$i');
        }
      }
    }
  }

  num getTotal() {
    if (numbers.isEmpty) {
      return 0;
    }
    return numbers.values.reduce((a, b) => a + b);
  }
}
