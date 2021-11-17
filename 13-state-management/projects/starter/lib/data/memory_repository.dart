import 'dart:core';
import 'package:flutter/foundation.dart';
// Contains interface definition
import 'repository.dart';
// Import the Recipe and Ingredient class definitions
import 'models/models.dart';

// Memory repository is for storing data in temporary. This will be a temp
// solution as the data is lost when the app is restarted.
// Extends `Repository` and uses Flutter's ChangeNotifier to enable listeners
// and notify those listeners of any changes.
class MemoryRepository extends Repository with ChangeNotifier {
  // Init current list of recipes
  final List<Recipe> _currentRecipes = <Recipe>[];
  // Init current list of ingredients
  final List<Ingredient> _currentIngredients = <Ingredient>[];

  @override
  List<Recipe> findAllRecipes() {
    return _currentRecipes;
  }

  @override
  Recipe findRecipeById(int id) {
    return _currentRecipes.firstWhere((recipe) => recipe.id == id);
  }

  @override
  List<Ingredient> findAllIngredients() {
    return _currentIngredients;
  }

  @override
  List<Ingredient> findRecipeIngredients(int recipeId) {
    final recipe = findRecipeById(recipeId);
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();
    return recipeIngredients;
  }

  @override
  int insertRecipe(Recipe recipe) {
    _currentRecipes.add(recipe);
    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }
    notifyListeners();
    // Meant to return the id of the inserted recipe, but it's not needed
    // so return 0.
    return 0;
  }

  @override
  List<int> insertIngredients(List<Ingredient> ingredients) {
    // Check that there are actually ingredients to insert
    if (ingredients.length != 0) {
      _currentIngredients.addAll(ingredients);
      notifyListeners();
    }
    // Returns list of Ids added, but it's not empty list for now.
    return <int>[];
  }

  @override
  void deleteRecipe(Recipe recipe) {
    _currentRecipes.remove(recipe);
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
    // Notify listeners that the data has changed.
    notifyListeners();
  }

  @override
  void deleteIngredient(Ingredient ingredient) {
    _currentIngredients.remove(ingredient);
  }

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    // Remove all ingredients that are in the passed in list
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));
    notifyListeners();
  }

  @override
  void deleteRecipeIngredients(int recipeId) {
    // Go through ingredient list, removing ingredients with the given recipeId.
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);
    notifyListeners();
  }

  // No need to do anything here for memory repository, but the methods do need
  // to be implemented.
  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
