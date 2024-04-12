class Tokenizer {
  static List<List<String>> tokenize(String input) {
    
    final lines = input.split('\n');
    return lines.map((line) => line.split(' ')).toList();
  }
}
