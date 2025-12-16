import 'dart:convert';

import 'package:buy_n_sell/api_urls/api_urls.dart';
import 'package:buy_n_sell/model_class/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryApi{

  List<CategoryModel> categories = [];

  Future<void> loadCategories() async{
    var url = Uri.parse(ApiUrl.viewCategories);

    var response = await http.get(url);

    if(response.statusCode == 200){
      print(response.body);

      var jsonData = jsonDecode(response.body);

      categories.clear();

      for (var item in jsonData) {
        categories.add(CategoryModel.fromJson(item));
      }

      for (var c in categories) {
        print("Category Name: ${c.name}");

      }

    }
  }
  
}