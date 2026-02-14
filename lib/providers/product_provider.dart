import 'package:flutter/material.dart';
import '../model_class/product_attribute_model.dart';
import '../model_class/product_model.dart';
import '../screens/product_section/product_api.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApi _productApi = ProductApi();

  // Separate lists
  List<ProductModel> _allProducts = [];

  bool _isLoading = false;
  String? _error;

  List<ProductModel> get allProducts => _allProducts;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all products
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_allProducts.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _productApi.loadProducts();
      _allProducts = _productApi.products;
    } catch (e) {
      _error = "Failed to load products";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductAttributes(String productId) async {
    try {
      List<ProductAttributeModel> attrs =
      await _productApi.loadProductAttributes(productId);

      final productIndex =
      _allProducts.indexWhere((p) => p.id == productId);

      if (productIndex != -1) {
        _allProducts[productIndex].attributes = attrs;
        notifyListeners();
      }
    } catch (e) {
      print("Error loading attributes: $e");
    }
  }



}
