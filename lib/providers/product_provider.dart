import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_urls/api_urls.dart';
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

  Future<void> fetchSingleProduct(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.viewProducts}?id=$id"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final product = ProductModel.fromJson(data.first);

          // Remove old if exists
          allProducts.removeWhere((p) => p.id == id);

          // Add fresh product
          allProducts.add(product);
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }


}
