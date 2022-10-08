import 'package:f_link/f_link.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late AblLink link;

  @override
  void initState() {
    super.initState();
    link = AblLink.create(100);
    link.enable(true);
  }

  @override
  Widget build(BuildContext context) {
    return Text("enabled: ${link.isEnabled()}");
  }
}
