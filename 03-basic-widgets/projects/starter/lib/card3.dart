import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';

class Card3 extends StatelessWidget {
  const Card3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(
          width: 350,
          height: 450,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mag2.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                // Position widgets to the left of the Column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.book,
                    color: Colors.white,
                    size: 40,
                  ),
                  // 8px vertical space
                  const SizedBox(height: 8),
                  Text(
                    'Recipe Trends',
                    style: FooderlichTheme.darkTextTheme.headline2,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Center(
              child:
                  // Puts children adjacent if possible, if not enough space,
                  // just wrap to the next line
                  Wrap(
                      // Place children as close to the left as possible
                      alignment: WrapAlignment.start,
                      // 12 px space between each child
                      spacing: 12,
                      // the list of Chip widgets
                      children: [
                    // Displays text and image avatars, also performs user
                    // actions like tap and delete
                    Chip(
                      label: Text('Healthy',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                      onDeleted: () {
                        print('delete');
                      },
                    ),
                    Chip(
                      label: Text('Vegan',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                      onDeleted: () {
                        print('delete');
                      },
                    ),
                    Chip(
                      label: Text('Carrots',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                    Chip(
                      label: Text('Greens',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                      onDeleted: () {
                        print('delete');
                      },
                    ),
                    Chip(
                      label: Text('Wheat',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                    Chip(
                      label: Text('Lemongrass',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                      onDeleted: () {
                        print('delete');
                      },
                    ),
                    Chip(
                      label: Text('Mint',
                          style: FooderlichTheme.darkTextTheme.bodyText1),
                      backgroundColor: Colors.black.withOpacity(0.7),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
