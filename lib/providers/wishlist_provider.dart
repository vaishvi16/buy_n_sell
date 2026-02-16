import 'package:flutter/material.dart';

import '../helper_class/db_helper/wishlist_db.dart';


class WishlistProvider extends ChangeNotifier {
  final WishlistDb _db = WishlistDb();

  Map<String, Map<String, String>> _wishlistData = {};

  Map<String, Map<String, String>> get wishlistData => _wishlistData;

  Set<String> get wishlistIds => _wishlistData.keys.toSet();

  Future<void> loadWishlist() async {
    _wishlistData = await _db.getWishlistData();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistData.containsKey(productId);
  }

  Future<void> toggleWishlist(
      String productId,
      Map<String, String> attributes,
      ) async {
    if (isInWishlist(productId)) {
      final oldAttributes = _wishlistData[productId]!;

      // Check if attributes changed
      final hasChanged = !_mapEquals(oldAttributes, attributes);

      if (hasChanged) {
        // Only update attributes, don't remove
        await _db.addToWishlist(productId, attributes);
        _wishlistData[productId] = attributes;
      } else {
        // No change in attributes -> toggle off
        await _db.removeFromWishlist(productId);
        _wishlistData.remove(productId);
      }
    } else {
      // Not in wishlist -> add
      await _db.addToWishlist(productId, attributes);
      _wishlistData[productId] = attributes;
    }

    notifyListeners();
  }

  /// Helper to compare two maps
  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (!b.containsKey(key) || b[key] != a[key]) return false;
    }
    return true;
  }

}
