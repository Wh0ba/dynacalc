import 'package:dynacalc/expression_analyzer.dart';
import 'package:dynacalc/extensions/number_colorizer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> fields = [''];
  final Map<int, String> units = {0: ''};
  late List<NumberColorizer> controllers = [];
  //key is the index of the field, while num is the value of the evaluated expression
  final Map<int, num> numbers = {};

  @override
  void initState() {
    controllers = fields.map((e) => NumberColorizer()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DynaCalc')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 1.7,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1),
                          ),
                          color: Color(0xFFF4F5F5)),
                    ),
                  ),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: (index == fields.length)
                                ? ListTile(
                                    title: IconButton(
                                      icon: const Icon(
                                          Icons.add_circle_outline_sharp),
                                      onPressed: () {
                                        setState(() {
                                          fields.add('');
                                          controllers.add(NumberColorizer());
                                        });
                                      },
                                    ),
                                  )
                                : TextField(
                                    controller: controllers[index],
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          numbers.remove(index);
                                        });
                                        return;
                                      }
                                      setState(() {
                                        final result = ExpressionAnalyzer
                                            .analyzeAndEvaluate(value,
                                                (currencyPrefix) {
                                          setState(() {
                                            units[index] = currencyPrefix;
                                          });
                                        });
                                        if (result != null) {
                                          numbers[index] = result;
                                        } else {
                                          numbers.remove(index);
                                        }
                                      });
                                    },
                                    // controller: NumberColorizer(),
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: const InputDecoration(
                                      border: null,
                                      hintText: '',
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                '${units[index] ?? ''} ${numbers[index] ?? ''}'),
                          ))
                        ],
                      );
                    },
                    itemCount: fields.length + 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
