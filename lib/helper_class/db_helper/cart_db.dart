// cart_db.dart
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class CartDb {
  static const _tableName = 'cart';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.database; // Reuse shared DB
    return _database!;
  }

  Future<void> addToCart(String productId) async {
    final db = await database;
    await db.insert(
      _tableName,
      {
        'productId': productId,
        'quantity': 1,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final db = await database;
    await db.update(
      _tableName,
      {'quantity': quantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> removeFromCart(String productId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<Map<String, int>> getCartItems() async {
    final db = await database;
    final result = await db.query(_tableName);

    return {
      for (var row in result) row['productId'] as String: row['quantity'] as int
    };
  }

  Future<bool> isInCart(String productId) async {
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
