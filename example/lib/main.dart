import 'dart:io';

import 'package:flutter/material.dart';
import 'package:f_link/f_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final linkProvider = Provider((_) {
//   return AblLink.create(120.0);
// });

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Link Plugin Test'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  // late AblLink? link;
  bool linkEnabled = false;

  @override
  void initState() {
    super.initState();

    // link = AblLink.create(120.0);
    // link.enable(true);
  }

  @override
  void dispose() {
    // link.enable(false);
    // link.destroy();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Switch(
          value: linkEnabled,
          onChanged: (bool newVal) {
            setState(() {
              linkEnabled = newVal;
            });
            if (newVal) {
              {
                // ref.read(linkProvider).enable(true);
                AblLink linko = AblLink.create(120);
                linko.enable(true);
                // linko = null;
                sleep(const Duration(seconds: 10));
                // linky.enable(true);
              }

              print("created");
            } else {
              print("done");
              // ref.read(linkProvider).enable(false);
              // link!.enable(false);
              // link!.destroy();

              // link = null;

              // link = null;

              // link.enable(false);
            }
          },
        ),
      ),
    );
  }
}
