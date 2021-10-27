import 'package:flutter/material.dart';
import '../components/grocery_tile.dart';
import '../models/models.dart';
import 'grocery_item_screen.dart';

class GroceryListScreen extends StatelessWidget {
  // Needs this to get the list of GroceryItems to display in the list
  final GroceryManager manager;

  const GroceryListScreen({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get list of GroceryItems from the manager's public getter which returns
    // and unmodifiable list
    final groceryItems = manager.groceryItems;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        // Sets number of items in the list
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          final item = groceryItems[index];
          // TODO 28: Wrap in a Dismissable
          // TODO 27: Wrap in an InkWell
          // Get the current GroceryItem to construct a GroceryTile
          return GroceryTile(
            key: Key(item.id),
            item: item,
            // Callback handler for tapping the checkbox
            onComplete: (change) {
              // Checks if there is a change and toggles the item's isComplete
              // status through the manager.
              if (change != null) {
                manager.completeItem(index, change);
              }
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
