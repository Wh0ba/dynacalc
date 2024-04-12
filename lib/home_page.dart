import 'package:dynacalc/word_engine.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WordEngine wordEngine;
  final Map<int, num> numbers = {};
  @override
  void initState() {
    wordEngine = WordEngine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DynaCalc')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.3,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  wordEngine.processString(value);
                });
              },
              expands: true,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your expression here',
              ),
            ),
          ),
          SizedBox(
              child: Text(wordEngine.numbers.entries
                  .map((token) => '${token.key}:${token.value}')
                  .join('\n'))),
        ],
      ),
    );
  }
}
