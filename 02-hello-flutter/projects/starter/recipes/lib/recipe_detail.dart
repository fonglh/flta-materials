import 'package:flutter/material.dart';
import 'recipe.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetail({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _RecipeDetailState createState() {
    return _RecipeDetailState();
  }
}

class _RecipeDetailState extends State<RecipeDetail> {
  int _sliderVal = 1;

  @override
  Widget build(BuildContext context) {
    // Scaffold defines the page's general structure
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.label),
      ),
      body: SafeArea(
        // SafeArea keeps the app from getting too close to OS interfaces
        // like the notch or interactive area of most iPhones
        child: Column(
          children: <Widget>[
            // Resizes the image to a fixed width, but width will adjust to fit
            // aspect ratio.
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image(
                image: AssetImage(widget.recipe.imageUrl),
              ),
            ),
            // spacer
            const SizedBox(
              height: 4,
            ),
            // Different style from the main card to demo flexibility
            Text(
              widget.recipe.label,
              style: const TextStyle(fontSize: 18),
            ),
            // Expanded widget fills up the space in a Column
            Expanded(
              // ListView with 1 row per ingredient
              child: ListView.builder(
                padding: const EdgeInsets.all(7.0),
                itemCount: widget.recipe.ingredients.length,
                itemBuilder: (BuildContext context, int index) {
                  final ingredient = widget.recipe.ingredients[index];
                  // Text that uses string interpolation
                  // TODO: Add ingredient.quantity
                  return Text('${ingredient.quantity * _sliderVal} '
                      '${ingredient.measure} '
                      '${ingredient.name}');
                },
              ),
            ),

            Slider(
              // min, max, divisions define how the slider moves.
              // here, 1-10 with 10 discrete stops
              min: 1,
              max: 10,
              divisions: 10,
              // Updates as _sliverVal changes
              label: '${_sliderVal * widget.recipe.servings} servings',
              // slider works in double values, so need to convert
              value: _sliderVal.toDouble(),
              // Convert back to int with `round`
              onChanged: (newValue) {
                setState(() {
                  _sliderVal = newValue.round();
                });
              },
              // section between minimum value and thumb
              activeColor: Colors.green,
              // section from thumb to the rest of the slider
              inactiveColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
