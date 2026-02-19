import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../api_urls/api_urls.dart';
import '../model_class/category_model.dart';
import '../shared_pref/shared_pref.dart';

class SellProductProvider extends ChangeNotifier {

  List<CategoryModel> categories = [];
  String? selectedCategoryId;
  String? selectedImagePath;
  bool isLoading = false;

  // FETCH CATEGORIES

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiUrl.viewCategories));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        print("Failed to fetch categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }


  // SET IMAGE

  void setInitialImage(String? path) {
    selectedImagePath = path;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      selectedImagePath = image.path;
      notifyListeners();
    }
  }

  void setCategory(String? value) {
    selectedCategoryId = value;
    notifyListeners();
  }

  // SELL PRODUCT

  Future<String> sellProduct({
    required String name,
    required String description,
    required String price,
  }) async {

    if (selectedImagePath == null ||
        selectedCategoryId == null ||
        name.isEmpty ||
        price.isEmpty ||
        description.isEmpty) {
      return "All fields are required!";
    }

    isLoading = true;
    notifyListeners();

    String? userId = await SharedPref.getUserId();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiUrl.insertProducts),
    );

    request.fields['user_id'] = userId ?? "";
    request.fields['cat_id'] = selectedCategoryId!;
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['bid_status'] = "inactive";

    request.files.add(
      await http.MultipartFile.fromPath('image', selectedImagePath!),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    isLoading = false;
    notifyListeners();

    print("response data for sell product provider: $responseData");

    if (response.statusCode == 200  && responseData.contains("Product Inserted Successfully")) {
      print("response data when status code 200");
      return "success";
    } else {
      print("response data failed : ${response.statusCode}");
      return "failed: $responseData";
    }
  }
}
