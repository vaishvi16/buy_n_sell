// wishlist_db.dart
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class WishlistDb {
  static const _tableName = 'wishlist';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseHelper.database;
    return _database!;
  }

  Future<void> addToWishlist(
      String productId,
      Map<String, String> attributes,
      ) async {
    final db = await database;

    await db.insert(
      _tableName,
      {
        'productId': productId,
        'attributes': jsonEncode(attributes),
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<Map<String, Map<String, String>>> getWishlistData() async {
    final db = await database;
    final result = await db.query(_tableName);

    return {
      for (var row in result)
        row['productId'] as String:
        Map<String, String>.from(
          jsonDecode(row['attributes'] as String),
        )
    };
  }
}
