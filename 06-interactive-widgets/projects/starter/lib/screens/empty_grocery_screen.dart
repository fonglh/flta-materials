import 'package:flutter/material.dart';

class EmptyGroceryScreen extends StatelessWidget {
  const EmptyGroceryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 30 px padding on all sides
    return Padding(
      padding: const EdgeInsets.all(30.0),
      // All other widgets are centered
      child: Center(
        // Handles vertical layout of the other widgets
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FLexible gives the child to fill the available space in the main
            // axis
            Flexible(
                child: AspectRatio(
              // this is a double, but Flutter docs say to write it as
              // width/height instead
              aspectRatio: 1 / 1,
              child: Image.asset('assets/fooderlich_assets/empty_list.png'),
            )),
            const Text(
              'No Groceries',
              style: TextStyle(fontSize: 21.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Shopping for ingredients?\n'
              'Tap the + button to write them down!',
              textAlign: TextAlign.center,
            ),
            // TODO 7: Add browse recipes button
          ],
        ),
      ),
    );
  }
}
