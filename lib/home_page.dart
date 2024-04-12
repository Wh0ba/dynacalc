import 'package:dynacalc/word_engine.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WordEngine wordEngine;
  late final NumberColorizer _controller;
  final Map<int, num> numbers = {};
  @override
  void initState() {
    wordEngine = WordEngine();
    _controller = NumberColorizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('DynaCalc')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Total: ${wordEngine.getTotal()}',
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.5,
                child: TextField(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        wordEngine.numbers.clear();
                      });
                      return;
                    }
                    setState(() {
                      wordEngine.processString(value);
                    });
                  },
                  expands: true,
                  maxLines: null,
                  controller: _controller,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Enter your expression here',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberColorizer extends TextEditingController {
  final Pattern pattern;

  NumberColorizer()
      : pattern = RegExp(r'([0-9]+\.?[0-9]*|\.?[0-9]+)', caseSensitive: false);
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
