import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

// To create instances of Response
import 'package:chopper/chopper.dart';
//`show` means those classes should be visible in the app
import 'package:flutter/services.dart' show rootBundle;
import '../network/model_response.dart';
import '../network/recipe_model.dart';

class MockService {
  late APIRecipeQuery _currentRecipes1;
  late APIRecipeQuery _currentRecipes2;
  // Creates a number between 0 and 1
  Random nextRecipe = Random();

  // Called by Provider, which just calls `loadRecipes`
  void create() {
    loadRecipes();
  }

  void loadRecipes() async {
    // rootBundle loads the JSON file as a string
    var jsonString = await rootBundle.loadString('assets/recipes1.json');
    // jsonDecode creates a map that APIRecipeQuery will use to get a list of
    // recipes
    _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
    jsonString = await rootBundle.loadString('assets/recipes2.json');
    _currentRecipes2 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
  }

  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to) {
    // Use the random field to pick a random integer, either 0 or 1
    switch (nextRecipe.nextInt(2)) {
      case 0:
        // Wrap the APIRecipeQuery in Success, Response and Future
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1)));
      case 1:
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes2)));
      default:
        return Future.value(Response(http.Response('Dummy', 200, request: null),
            Success<APIRecipeQuery>(_currentRecipes1)));
    }
  }
}
