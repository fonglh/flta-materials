import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'recipe_model.dart';

abstract class ServiceInterface {
  // Same parameters and return values as RecipeService and MockService.
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      String query, int from, int to);
}
