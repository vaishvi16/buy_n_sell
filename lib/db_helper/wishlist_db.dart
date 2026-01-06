import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WishlistDb {
  static const _dbName = 'buy_n_sell.db';
  static const _tableName = 'wishlist';

  // Singleton DB instance
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT UNIQUE,
            createdAt INTEGER
          )
        ''');
      },
    );
  }

  // ---------------- CRUD ----------------

  Future<void> addToWishlist(String productId) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'productId': productId,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<void> removeFromWishlist(String productId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<List<String>> getWishlistProductIds() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((e) => e['productId'] as String).toList();
  }

  Future<bool> isInWishlist(String productId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
