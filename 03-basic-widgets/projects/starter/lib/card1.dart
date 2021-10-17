import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';

class Card1 extends StatelessWidget {
  const Card1({Key? key}) : super(key: key);

  final String category = 'Editor\'s Choice';
  final String title = 'The Art of Dough';
  final String description = 'Learn to make the perfect bread.';
  final String chef = 'Ray Wenderlich';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(children: [
          Text(
            category,
            style: FooderlichTheme.darkTextTheme.bodyText1,
          ),
          Positioned(
              child: Text(
                title,
                style: FooderlichTheme.darkTextTheme.headline5,
              ),
              top: 20),
          Positioned(
              child: Text(
                description,
                style: FooderlichTheme.darkTextTheme.bodyText1,
              ),
              bottom: 30,
              right: 0),
          Positioned(
              child: Text(
                chef,
                style: FooderlichTheme.darkTextTheme.bodyText1,
              ),
              bottom: 10,
              right: 0),
        ]),
        padding: const EdgeInsets.all(16),
        // Constrains the container's size to width of 350px and height of 450px
        constraints: const BoxConstraints.expand(
          width: 350,
          height: 450,
        ),
        // BoxDecoration describes how to draw a box
        decoration: const BoxDecoration(
          // DecorationImage tells the box to paint an image
          image: DecorationImage(
            image: AssetImage('assets/mag1.png'),
            // Covers the entire box with the image
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
