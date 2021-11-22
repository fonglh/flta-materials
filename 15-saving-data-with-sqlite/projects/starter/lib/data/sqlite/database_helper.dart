import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import '../models/models.dart';

class DatabaseHelper {
  // Constants for db name and version
  static const _databaseName = 'MyRecipes.db';
  static const _databaseVersion = 1;

  // Definte table names
  static const recipeTable = 'Recipe';
  static const ingredientTable = 'Ingredient';
  static const recipeId = 'recipeId';
  static const ingredientId = 'ingredientId';

  // `late` indicate it's non-nullable and will be initialised after it's been
  // declared
  static late BriteDatabase _streamDatabase;

  // make this a singleton class
  // Make constructor private and provide a public static instance.
  // Singleton class is needed to prevent other classes from creating multiple
  // instances of this helper class and initializing the db more than once.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // Will use this to prevent concurrent access
  static var lock = Lock();

  // only have a single app-wide reference to the database
  // Private sqflite database instance
  static Database? _database;

  // SQL code to create the database table
  // Pass sqflite db into this method to create the tables.
  Future _onCreate(Database db, int version) async {
    // Create Recipe table with the same columns as the model.
    // Use REAL for double values.
    await db.execute('''
        CREATE TABLE $recipeTable (
          $recipeId INTEGER PRIMARY KEY,
          label TEXT,
          image TEXT,
          url TEXT,
          calories REAL,
          totalWeight REAL,
          totalTime REAL
        )
        ''');
    await db.execute('''
        CREATE TABLE $ingredientTable (
          $ingredientId INTEGER PRIMARY KEY,
          $recipeId INTEGER,
          name TEXT,
          weight REAL
        )
        ''');
  }

  // this opens the database (and creates it if it doesn't exist)
  // Return a Future as it's an async operation
  Future<Database> _initDatabase() async {
    // Will store db file in the app's document directory
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Remember to turn off debugging before deploying app to store(s).
    Sqflite.setDebugModeOn(true);

    // Use sqflite's in-built method to open/create the database
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Other methods and classes can use this getter to access the db
  Future<Database> get database async {
    // Return existing db if it is not null, since it's already created
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data
    await lock.synchronized(() async {
      // lazily instantiate the db the first time it is accessed
      if (_database == null) {
        _database = await _initDatabase();
        // Wrap _database in a BriteDatabase object
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  // Will use the streamDatabase for the stream methods in the repository, as
  // well as to insert and delete data
  Future<BriteDatabase> get streamDatabase async {
    // Await the result because it also creates _streamDatabase
    await database;
    return _streamDatabase;
  }

  List<Recipe> parseRecipes(List<Map<String, dynamic>> recipeList) {
    final recipes = <Recipe>[];
    // Iterate over list of recipes in JSON format
    recipeList.forEach((recipeMap) {
      final recipe = Recipe.fromJson(recipeMap);
      recipes.add(recipe);
    });
    return recipes;
  }

  List<Ingredient> parseIngredients(List<Map<String, dynamic>> ingredientList) {
    final ingredients = <Ingredient>[];
    ingredientList.forEach((ingredientMap) {
      final ingredient = Ingredient.fromJson(ingredientMap);
      ingredients.add(ingredient);
    });
    return ingredients;
  }

  Future<List<Recipe>> findAllRecipes() async {
    // Get the database
    final db = await instance.streamDatabase;
    // Use `query` to get all the recipes
    final recipeList = await db.query(recipeTable);
    // parse to a list of Recipes
    final recipes = parseRecipes(recipeList);
    return recipes;
  }

  // async* and yield* keywords are used to signal a stream
  Stream<List<Recipe>> watchAllRecipes() async* {
    final db = await instance.streamDatabase;
    // `yield` creates a stream using the query
    yield* db
        // create a query using recipeTable
        .createQuery(recipeTable)
        // For each row, convert the row to a list of recipes.
        .mapToList((row) => Recipe.fromJson(row));
  }

  // async* and yield* keywords are used to signal a stream
  Stream<List<Ingredient>> watchAllIngredients() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(ingredientTable)
        .mapToList((row) => Ingredient.fromJson(row));
  }

  Future<Recipe> findRecipeById(int id) async {
    final db = await instance.streamDatabase;
    // could also use `rawQuery` and write raw SQL commands
    final recipeList = await db.query(recipeTable, where: 'id = $id');
    final recipes = parseRecipes(recipeList);
    return recipes.first;
  }

  Future<List<Ingredient>> findAllIngredients() async {
    final db = await instance.streamDatabase;
    final ingredientList = await db.query(ingredientTable);
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  Future<List<Ingredient>> findRecipeIngredients(int recipeId) async {
    final db = await instance.streamDatabase;
    // use `where` clause to find ingredients belonging to a specific recipe
    final ingredientList =
        await db.query(ingredientTable, where: 'recipeId = $recipeId');
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  // Take table name and JSON map
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    // Use Sqlbrite's insert
    return db.insert(table, row);
  }

  Future<int> insertRecipe(Recipe recipe) {
    // Return values from `insert` using recipe's table and JSON data
    return insert(recipeTable, recipe.toJson());
  }

  Future<int> insertIngredient(Ingredient ingredient) {
    // Return values from `insert` using ingredient's table and JSON data
    return insert(ingredientTable, ingredient.toJson());
  }

  // Private function to delete data from the table with the provided
  // column and row id.
  Future<int> _delete(String table, String columnId, int id) async {
    final db = await instance.streamDatabase;
    // Delete a row where columnId equals to the passed in id
    return db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(Recipe recipe) async {
    if (recipe.id != null) {
      return _delete(recipeTable, recipeId, recipe.id!);
    } else {
      return Future.value(-1);
    }
  }

  Future<int> deleteIngredient(Ingredient ingredient) async {
    if (ingredient.id != null) {
      return _delete(ingredientTable, ingredientId, ingredient.id!);
    } else {
      return Future.value(-1);
    }
  }

  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    ingredients.forEach((ingredient) {
      if (ingredient.id != null) {
        _delete(ingredientTable, ingredientId, ingredient.id!);
      }
    });
    return Future.value();
  }

  Future<int> deleteRecipeIngredients(int id) async {
    final db = await instance.streamDatabase;
    // If you use whereArgs, you need to use a ? for each item in the list of
    // arguments. Notice the last method. It uses whereArgs: [id]. This is an
    // array of parameters. For every question mark, you need an entry in the
    // array.
    return db.delete(ingredientTable, where: '$recipeId = ?', whereArgs: [id]);
  }

  void close() {
    _streamDatabase.close();
  }
}
