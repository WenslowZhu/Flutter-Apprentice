import 'package:flutter/material.dart';
import 'open_container.dart';
import 'fooderlich_theme.dart';
// import 'home.dart';

void main() {
  // 1
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget {
  // 2
  const Fooderlich({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final theme = FooderlichTheme.dark();

    return MaterialApp(
      theme: theme,
      title: 'Fooderlich',
      home: const OpenContainerTransformDemo(),
    );
  }
}