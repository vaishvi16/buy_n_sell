import 'package:flutter/material.dart';

import '../helper_class/db_helper/cart_db.dart';

class CartProvider extends ChangeNotifier {
  final CartDb _db = CartDb();

  Map<String, int> _cartItems = {};

  Map<String, int> get cartItems => _cartItems;

  // Load cart from DB
  Future<void> loadCart() async {
    _cartItems = await _db.getCartItems();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _cartItems.containsKey(productId);
  }

  Future<void> addToCart(String productId) async {
    if (isInCart(productId)) {
      increaseQty(productId);
    } else {
      await _db.addToCart(productId);
      _cartItems[productId] = 1;
      notifyListeners();
    }
  }

  Future<void> increaseQty(String productId) async {
    final qty = _cartItems[productId]! + 1;
    _cartItems[productId] = qty;
    await _db.updateQuantity(productId, qty);
    notifyListeners();
  }

  Future<void> decreaseQty(String productId) async {
    final qty = _cartItems[productId]!;

    if (qty <= 1) {
      await removeFromCart(productId);
    } else {
      final newQty = qty - 1;
      _cartItems[productId] = newQty;
      await _db.updateQuantity(productId, newQty);
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId) async {
    await _db.removeFromCart(productId);
    _cartItems.remove(productId);
    notifyListeners();
  }

  int get totalItems {
    int total = 0;
    for (final qty in _cartItems.values) {
      total += qty;
    }
    return total;
  }
}
