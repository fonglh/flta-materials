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

// TODO: Add parseRecipes here

}
