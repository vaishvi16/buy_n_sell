// database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'buy_n_sell.db';
  static const _dbVersion = 1;

  static Database? _database;

  // Get the database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database and create tables
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Create cart table
        await db.execute('''
          CREATE TABLE cart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT UNIQUE,
            quantity INTEGER,
            createdAt INTEGER
          )
        ''');

        // Create wishlist table
        await db.execute('''
          CREATE TABLE wishlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT UNIQUE,
            createdAt INTEGER
          )
        ''');
      },
    );
  }
}
