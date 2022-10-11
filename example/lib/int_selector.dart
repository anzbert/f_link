import 'package:flutter/material.dart';

class IntSelectorTile extends StatelessWidget {
  /// Int Value selector ListTile with Up and Down arrow and an optional Reset button.
  const IntSelectorTile(
      {this.label = "#label",
      required this.readValue,
      required this.setValue,
      this.resetFunction,
      Key? key})
      : super(key: key);

  final String label;
  final int readValue;
  final void Function(int x) setValue;
  final Function? resetFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(label),
          if (resetFunction != null)
            TextButton(
              onPressed: () => resetFunction!(),
              child: const Text("Reset"),
            ),
        ],
      ),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (readValue - 1 >= 0) setValue(readValue - 1); // no negatives
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.remove),
            ),
            Text(
              readValue.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                setValue(readValue + 1);
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.add),
            ),
          ]),
    );
  }
}
