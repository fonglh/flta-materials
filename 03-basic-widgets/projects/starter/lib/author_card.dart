import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';
import 'circle_image.dart';

class AuthorCard extends StatelessWidget {
  final String authorName;
  final String title;
  final ImageProvider? imageProvider;

  const AuthorCard({
    Key? key,
    required this.authorName,
    required this.title,
    this.imageProvider,
  }) : super(key: key);

  // Grouped in a Container and uses a Row widget to lay out the other widgets
  // horizontally
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        // Adds extra space between the outer Row's children, placing the heart
        // shaped IconButton at the far right of the screen.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Inner row groups the CircleImage with the author's Text info
          Row(
            children: [
              CircleImage(
                imageProvider: imageProvider,
                imageRadius: 20,
              ),
              // 8 pixels of padding between image and the text
              const SizedBox(width: 8),
              // lays out author name and job title vertically with a Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorName,
                      style: FooderlichTheme.lightTextTheme.headline2),
                  Text(title, style: FooderlichTheme.lightTextTheme.headline3),
                ],
              )
            ],
          ),
          IconButton(
              onPressed: () {
                const snackBar = SnackBar(content: Text('Favourite pressed'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(Icons.favorite_border),
              iconSize: 30,
              color: Colors.grey[400])
        ],
      ),
    );
  }
}
