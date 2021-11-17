import 'models/models.dart';

// An `abstract class` is an interface
abstract class Repository {
  // Interface methods for finding stuff
  List<Recipe> findAllRecipes();
  Recipe findRecipeById(int id);
  List<Ingredient> findAllIngredients();
  List<Ingredient> findRecipeIngredients(int recipeId);

  // Interface methods to insert a new recipe and add given ingredients
  int insertRecipe(Recipe recipe);
  List<int> insertIngredients(List<Ingredient> ingredients);

  // Interface methods for deleting stuff.
  void deleteRecipe(Recipe recipe);
  void deleteIngredient(Ingredient ingredient);
  void deleteIngredients(List<Ingredient> ingredients);
  void deleteRecipeIngredients(int recipeId);

  // Allow repo to initialize. Databases might need to do some startup work
  Future init();
  // Close the repo.
  void close();
}
