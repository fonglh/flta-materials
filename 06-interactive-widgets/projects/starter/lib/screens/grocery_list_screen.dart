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
          return Dismissible(
            // Flutter needs this to find and remove the right element in the
            // tree
            key: Key(item.id),
            // Sets the direction the user can swipe to dismiss
            direction: DismissDirection.endToStart,
            // Widget to display behind the widget being swiped
            // Red with a white trashcan on center right
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete_forever,
                  color: Colors.white, size: 50.0),
            ),
            // lets me know when user swiped away a grocery tile
            onDismissed: (direction) {
              // Pass index for grocery manager to delete the item.
              manager.deleteItem(index);
              // Show snack bar to inform the user what item got deleted
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} dismissed')));
            },
            // Wrap GroceryTile in an InkWell
            child: InkWell(
              // Get the current GroceryItem to construct a GroceryTile
              child: GroceryTile(
                key: Key(item.id),
                item: item,
                // Callback handler for tapping the checkbox
                onComplete: (change) {
                  // Checks if there is a change and toggles the item's
                  // isComplete status through the manager.
                  if (change != null) {
                    manager.completeItem(index, change);
                  }
                },
              ),
              // Presents GroceryItemScreen for user to edit the current item.
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroceryItemScreen(
                              originalItem: item,
                              // Called by GroceryItemScreen when user updates
                              // an item
                              onUpdate: (item) {
                                // Updates item at the index
                                manager.updateItem(item, index);
                                // Dismisses GroceryItemScreen
                                Navigator.pop(context);
                              },
                              // Not called since we're updating and item
                              onCreate: (item) => {},
                            )));
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}
