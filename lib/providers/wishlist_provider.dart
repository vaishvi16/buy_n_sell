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
      await _db.addToWishlist(productId, attributes); // UPDATE instead of REMOVE
      _wishlistData[productId] = attributes;

    } else {
      await _db.addToWishlist(productId, attributes);
      _wishlistData[productId] = attributes;
    }
    notifyListeners();
  }
}
