import 'package:flutter/material.dart';
import '../screens/category_section/category_api.dart';
import '../model_class/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryApi _categoryApi = CategoryApi();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCategories() async {

    if (_categories.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _categoryApi.loadCategories();
      _categories = _categoryApi.categories;
    } catch (e) {
      _error = "Failed to load categories";
    }

    _isLoading = false;
    notifyListeners();
  }
}
