// wishlist_db.dart
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class WishlistDb {
  static const _tableName = 'wishlist';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.database; // Reuse shared DB
    return _database!;
  }

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
