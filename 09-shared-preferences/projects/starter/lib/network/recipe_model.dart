// Lets classes be marked as serializable.
import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

// Marks the class a serializable so the json_serializable plugin can generate
// the .g.dart file.
@JsonSerializable()
class APIRecipeQuery {
  // Conversion methods
  factory APIRecipeQuery.fromJson(Map<String, dynamic> json) =>
      _$APIRecipeQueryFromJson(json);

  Map<String, dynamic> toJson() => _$APIRecipeQueryToJson(this);

  // in the JSON, the query is called "q"
  @JsonKey(name: 'q')
  // the rest of the fields have matching names in the JSON
  String query;
  int from;
  int to;
  bool more;
  int count;
  List<APIHits> hits;

  APIRecipeQuery({
    // 'required' annotation means the fields are necessary when creating a new
    // instance.
    required this.query,
    required this.from,
    required this.to,
    required this.more,
    required this.count,
    required this.hits,
  });
}

// Marks class as serializable.
@JsonSerializable()
class APIHits {
  APIRecipe recipe;

  // Constructor that accepts a `recipe` parameter.
  APIHits({
    required this.recipe,
  });

  // JSON serialization methods.
  factory APIHits.fromJson(Map<String, dynamic> json) =>
      _$APIHitsFromJson(json);
  Map<String, dynamic> toJson() => _$APIHitsToJson(this);
}

@JsonSerializable()
class APIRecipe {
  // Define fields for the recipe. label is the text shown and image is the URL
  // of the image to show.
  String label;
  String image;
  String url;
  // Each recipe has a list of ingredients
  List<APIIngredients> ingredients;
  double calories;
  double totalWeight;
  double totalTime;

  APIRecipe({
    required this.label,
    required this.image,
    required this.url,
    required this.ingredients,
    required this.calories,
    required this.totalWeight,
    required this.totalTime,
  });

  // Factory methods for serializing JSON.
  factory APIRecipe.fromJson(Map<String, dynamic> json) =>
      _$APIRecipeFromJson(json);
  Map<String, dynamic> toJson() => _$APIRecipeToJson(this);
}

// Helper method to turn a calorie value into a string.
String getCalories(double? calories) {
  if (calories == null) {
    return '0 KCAL';
  }
  return calories.floor().toString() + ' KCAL';
}

// Another helper to turn weight into a string.
String getWeight(double? weight) {
  if (weight == null) {
    return '0g';
  }
  return weight.floor().toString() + 'g';
}

@JsonSerializable()
class APIIngredients {
  // `name` field of this class maps to the JSON field named `text`.
  @JsonKey(name: 'text')
  String name;
  double weight;

  APIIngredients({
    required this.name,
    required this.weight,
  });

  // Factory methods for serializing JSON.
  factory APIIngredients.fromJson(Map<String, dynamic> json) =>
      _$APIIngredientsFromJson(json);
  Map<String, dynamic> toJson() => _$APIIngredientsToJson(this);
}
