import 'package:flutter/material.dart';
import 'package:f_link/f_link.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final linkProvider = Provider((_) => AblLink.create(120.0));

final test = Provider((ref) {
  ref.listen(linkProvider, (previous, next) {
    print("yoyoy");
  });
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'F_Link Example'),
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
  bool linkEnabled = false;

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
            setState(() => linkEnabled = newVal);
            ref.read(linkProvider).enable(newVal);
          },
        ),
      ),
    );
  }
}
