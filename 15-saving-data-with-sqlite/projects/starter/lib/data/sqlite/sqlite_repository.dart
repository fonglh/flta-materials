import 'dart:async';
// Include helper class, models, and repository interface.
import '../repository.dart';
import 'database_helper.dart';
import '../models/models.dart';

class SqliteRepository extends Repository {
  // Singleton instance of DatabaseHelper
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Recipe>> findAllRecipes() {
    return dbHelper.findAllRecipes();
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    return dbHelper.watchAllRecipes();
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    return dbHelper.watchAllIngredients();
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    return dbHelper.findRecipeById(id);
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return dbHelper.findAllIngredients();
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int id) {
    return dbHelper.findRecipeIngredients(id);
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    // return async Future
    return Future(() async {
      // Use helper to insert recipe and save the Id
      final id = await dbHelper.insertRecipe(recipe);
      // Set recipe class to the id.
      recipe.id = id;
      if (recipe.ingredients != null) {
        recipe.ingredients!.forEach((ingredient) {
          // Set each ingredients recipeId field to this id.
          // This is the foreign key.
          ingredient.recipeId = id;
        });
        // Insert all the ingredients. Before this can be done, they need to
        // have their recipeId set to the id of the recipe that was just
        // inserted.
        insertIngredients(recipe.ingredients!);
      }
      return id;
    });
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    return Future(() async {
      if (ingredients.length != 0) {
        // Create a list of new ingredient ids.
        final ingredientIds = <int>[];
        // Need to use insertIngredient, so everything must be wrapped in an
        // async Future.
        await Future.forEach(ingredients, (Ingredient ingredient) async {
          // Get the new ingredient's id
          final futureId = await dbHelper.insertIngredient(ingredient);
          ingredient.id = futureId;
          // Add the new ingredient's id to the return list.
          ingredientIds.add(futureId);
        });
        // Return the list of new Ids.
        return Future.value(ingredientIds);
      } else {
        return Future.value(<int>[]);
      }
    });
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) {
    // Call helper's deleteRecipe method.
    dbHelper.deleteRecipe(recipe);
    // Delete all of this recipe's ingredients
    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    dbHelper.deleteIngredient(ingredient);
    // Delete ingredients and ignore the number of deleted rows
    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    // Delete all ingredients in the list passed in
    dbHelper.deleteIngredients(ingredients);
    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) {
    // Delete all ingredients with the given recipeId
    dbHelper.deleteRecipeIngredients(recipeId);
    return Future.value();
  }

  // Call helper's init and close methods.
  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }
}
