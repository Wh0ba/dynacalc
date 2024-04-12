import 'package:dynacalc/tokenizer.dart';

class WordEngine {
  // This will store the encountered numbers as the index and the value of the number to prevent repeated numbers on each processing step
  final Map<int, num> numbers = {};
  void processString(String input) {
    final tokens = Tokenizer.tokenize(input);
    for (final (i, token) in tokens.indexed) {
      num? n = int.tryParse(token);
      if (n != null) {
        numbers[i] = n;
      } else {
        numbers.remove(i);
      }
    }
  }
}
