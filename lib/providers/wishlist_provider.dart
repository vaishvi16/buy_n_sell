import 'package:flutter/material.dart';

import '../db_helper/wishlist_db.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistDb _db = WishlistDb();

  Set<String> _wishlistIds = {};

  Set<String> get wishlistIds => _wishlistIds;

  // Load wishlist from DB
  Future<void> loadWishlist() async {
    final ids = await _db.getWishlistProductIds();
    _wishlistIds = ids.toSet();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistIds.contains(productId);
  }

  Future<void> toggleWishlist(String productId) async {
    if (isInWishlist(productId)) {
      await _db.removeFromWishlist(productId);
      _wishlistIds.remove(productId);
    } else {
      await _db.addToWishlist(productId);
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }
}
