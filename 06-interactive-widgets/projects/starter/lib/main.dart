import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fooderlich_theme.dart';
import 'home.dart';
import 'models/models.dart';

void main() {
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget {
  const Fooderlich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = FooderlichTheme.light();
    return MaterialApp(
      theme: theme,
      title: 'Fooderlich',
      // MultiProvider accepts a list of providers for Home's descendant widgets
      // to access. Use this when more than 1 Providers is needed by the widget
      // tree.
      home: MultiProvider(providers: [
        // ChangeNotifierProvider creates an instance of TabManager, which
        // listens to tab index changes and notifies its listeners
        ChangeNotifierProvider(create: (context) => TabManager())
        // TODO 10: Add GroceryManager Provider
      ], child: const Home()),
    );
  }
}
