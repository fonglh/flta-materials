import 'package:flutter/material.dart';
import 'recipe_detail.dart';
import 'recipe.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    // MaterialApp uses Material Design and is the widget that will be included in RecipeApp
    return MaterialApp(
      title: 'Recipe Calculator',
      // By copying the theme and replacing the color scheme with an updated copy lets you change the app’s colors.
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.grey,
          secondary: Colors.black,
        ),
      ),
      home: const MyHomePage(title: 'Recipe Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
          // Builds a list using a ListView
          child: ListView.builder(
              // Determines the number of rows the list has,
              // here it's the number of objects in the Recipe.samples list
              itemCount: Recipe.samples.length,
              // Builds the widget tree for each row
              itemBuilder: (BuildContext context, int index) {
                // GestureDetector detects gestures
                return GestureDetector(
                  // callback when widget is tapped
                  onTap: () {
                    // Navigator manages a stack of pages.
                    // `push` pushes a new Material page onto the stack
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      // destination page widget
                      return RecipeDetail(recipe: Recipe.samples[index]);
                    }));
                  },
                  // GestureDetector's child widget defines area where the gesture is active
                  child: buildRecipeCard(Recipe.samples[index]),
                );
              })),
    );
  }

  Widget buildRecipeCard(Recipe recipe) {
    return Card(
        // How high the card is off the screen, affecting the shadow
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        // Child is a Column, Column defines a vertical layout
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // 2 children in the column
            children: <Widget>[
              // 1st child is an image. AssetImage states that it's fetched from
              // local asset bundle defined in pubspec.yaml
              Image(image: AssetImage(recipe.imageUrl)),
              // Blank view with a fixed size
              const SizedBox(
                height: 14.0,
              ),
              // Text widget with the recipe label
              Text(recipe.label,
                  // customize text widgets with a style object
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Palantino',
                  ))
            ],
          ),
        ));
  }
}
