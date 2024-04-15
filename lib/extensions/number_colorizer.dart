
import 'package:flutter/material.dart';

class NumberColorizer extends TextEditingController {
  final Pattern pattern;

  NumberColorizer()
      : pattern = RegExp(r'((\$|\₺|\€|\£)?[0-9]+\.?[0-9]*|\.?[0-9]+)', caseSensitive: false);
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<InlineSpan> children = [];
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final text = match[0]!;
        children.add(TextSpan(
            text: text,
            style: style!.merge(const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold))));
        return text;
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return text;
      },
    );
    return TextSpan(style: style, children: children);
  }
}
