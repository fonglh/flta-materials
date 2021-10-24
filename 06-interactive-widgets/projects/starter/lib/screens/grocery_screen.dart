import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'empty_grocery_screen.dart';
import '../models/models.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton with a plus icon
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO 11: Present GroceryItemScreen
        },
      ),
      // Build the rest of the Grocery screen's subtree
      body: buildGroceryScreen(),
    );
  }

  Widget buildGroceryScreen() {
    // Wrap the widget inside a Consumer which listens for GroceryManager
    // state changes.
    // Should only wrap a Consumer around widgets that need it.
    // Wrapping at the top levevl would force it to rebuild the entire tree.
    return Consumer<GroceryManager>(
      // Consumer rebuilds the widgets below itself when grocery manager items
      // change
      builder: (context, manager, child) {
        if (manager.groceryItems.isNotEmpty) {
          // TODO 25: Add GroceryListScreen
          return Container();
        } else {
          return const EmptyGroceryScreen();
        }
      },
    );
  }
}
