import 'package:flutter/cupertino.dart';

import '../model_class/product_model.dart';
import '../screens/product_section/product_api.dart';

class CategoryProductProvider extends ChangeNotifier {
  final ProductApi _api = ProductApi();

  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProductByCategory(String? categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.loadProductsAsCategory(categoryId);
      _products = _api.products;
    } catch (e) {
      _error = "Failed to load products";
    }

    _isLoading = false;
    notifyListeners();
  }
}
