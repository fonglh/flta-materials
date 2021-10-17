import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';
import 'home.dart';

void main() {
  // runApp takes the main widget, which is Fooderlich
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget {
  const Fooderlich({Key? key}) : super(key: key);

  // Every stateless widget must override the `build` method
  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.dark();
    // Composes MaterialApp widget for Material look and feel
    return MaterialApp(
        theme: theme,
        title: 'Fooderlich',
        // Scaffold defines layout and structure of the app
        home: const Home());
  }
}
