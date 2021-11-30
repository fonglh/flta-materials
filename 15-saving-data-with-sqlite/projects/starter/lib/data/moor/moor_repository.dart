import 'dart:async';
import '../models/models.dart';

import '../repository.dart';
import 'moor_db.dart';

class MoorRepository extends Repository {
  // An instance of the Moor recipe database
  late RecipeDatabase recipeDatabase;
  // Handles recipes
  late RecipeDao _recipeDao;
  // Handles ingredients
  late IngredientDao _ingredientDao;
  // Stream that watches ingredients
  Stream<List<Ingredient>>? ingredientStream;
  // Stream that watches recipes
  Stream<List<Recipe>>? recipeStream;

  @override
  Future<List<Recipe>> findAllRecipes() {
    return _recipeDao.findAllRecipes().then<List<Recipe>>(
      (List<MoorRecipeData> moorRecipes) {
        final recipes = <Recipe>[];
        moorRecipes.forEach(
          (moorRecipe) async {
            // Convert each Moor recipe to a model recipe
            final recipe = moorRecipeToRecipe(moorRecipe);
            if (recipe.id != null) {
              recipe.ingredients = await findRecipeIngredients(recipe.id!);
            }
            recipes.add(recipe);
          },
        );
        return recipes;
      },
    );
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    // Calls the same method name on the recipeDao class and saves a instance
    // so multiple streams are not created.
    if (recipeStream == null) {
      recipeStream = _recipeDao.watchAllRecipes();
    }
    return recipeStream!;
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    if (ingredientStream == null) {
      final stream = _ingredientDao.watchAllIngredients();
      ingredientStream = stream.map(
        (moorIngredients) {
          final ingredients = <Ingredient>[];
          // Convert each ingredient from moor to model
          moorIngredients.forEach(
            (moorIngredient) {
              ingredients.add(moorIngredientToIngredient(moorIngredient));
            },
          );
          return ingredients;
        },
      );
    }
    return ingredientStream!;
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    return _recipeDao
        .findRecipeById(id)
        .then((listOfRecipes) => moorRecipeToRecipe(listOfRecipes.first));
  }

  // Almost like watchAllIngredients, except it doesn't return a stream
  @override
  Future<List<Ingredient>> findAllIngredients() {
    return _ingredientDao.findAllIngredients().then<List<Ingredient>>(
      (List<MoorIngredientData> moorIngredients) {
        final ingredients = <Ingredient>[];
        moorIngredients.forEach(
          (ingredient) {
            ingredients.add(moorIngredientToIngredient(ingredient));
          },
        );
        return ingredients;
      },
    );
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    return _ingredientDao.findRecipeIngredients(recipeId).then(
      (listOfIngredients) {
        final ingredients = <Ingredient>[];
        listOfIngredients.forEach(
          (ingredient) {
            ingredients.add(moorIngredientToIngredient(ingredient));
          },
        );
        return ingredients;
      },
    );
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    return Future(
      () async {
        final id =
            await _recipeDao.insertRecipe(recipeToInsertableMoorRecipe(recipe));
        if (recipe.ingredients != null) {
          // Set the recipe ID for each ingredient
          recipe.ingredients!.forEach(
            (ingredient) {
              ingredient.recipeId = id;
            },
          );
          insertIngredients(recipe.ingredients!);
        }
        return id;
      },
    );
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    return Future(
      () {
        if (ingredients.length == 0) {
          return <int>[];
        }
        final resultIds = <int>[];
        ingredients.forEach(
          (ingredient) {
            final moorIngredient =
                ingredientToInsertableMoorIngredient(ingredient);
            // Inserts the ingredient into the db and adds a new ID to the list
            _ingredientDao
                .insertIngredient(moorIngredient)
                .then((int id) => resultIds.add(id));
          },
        );
        return resultIds;
      },
    );
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) {
    if (recipe.id != null) {
      _recipeDao.deleteRecipe(recipe.id!);
    }
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    if (ingredient.id != null) {
      return _ingredientDao.deleteIngredient(ingredient.id!);
    } else {
      return Future.value();
    }
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    ingredients.forEach((ingredient) {
      if (ingredient.id != null) {
        _ingredientDao.deleteIngredient(ingredient.id!);
      }
    });
    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) async {
    final ingredients = await findRecipeIngredients(recipeId);
    return deleteIngredients(ingredients);
  }

  @override
  Future init() async {
    // Creates DB
    recipeDatabase = RecipeDatabase();
    // Gets instances of DAOs
    _recipeDao = recipeDatabase.recipeDao;
    _ingredientDao = recipeDatabase.ingredientDao;
  }

  @override
  void close() {
    recipeDatabase.close();
  }
}
