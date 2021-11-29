import 'package:moor_flutter/moor_flutter.dart';
import '../models/models.dart';

part 'moor_db.g.dart';

class MoorRecipe extends Table {
  IntColumn get id => integer().autoIncrement()();

  // First define the column type with classes that handle different types.
  // Each call returns a builder, so need another () to create it.
  TextColumn get label => text()();

  TextColumn get image => text()();

  TextColumn get url => text()();

  RealColumn get calories => real()();

  RealColumn get totalWeight => real()();

  RealColumn get totalTime => real()();
}

class MoorIngredient extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recipeId => integer()();

  TextColumn get name => text()();

  RealColumn get weight => real()();
}

@UseMoor(tables: [MoorRecipe, MoorIngredient], daos: [RecipeDao, IngredientDao])
// Moor generator creates _$RecipeDatabase, `part` command at the top will
// include this class.
class RecipeDatabase extends _$RecipeDatabase {
  RecipeDatabase()
      // Call the super class' constructor when creating the class.
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'recipes.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}


// TODO: Add RecipeDao here

// TODO: Add IngredientDao

// TODO: Add moorRecipeToRecipe here

// TODO: Add MoorRecipeData here

// TODO: Add moorIngredientToIngredient and MoorIngredientCompanion here
