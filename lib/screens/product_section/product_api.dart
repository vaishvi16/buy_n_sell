import 'dart:convert';

import 'package:buy_n_sell/api_urls/api_urls.dart';
import 'package:http/http.dart' as http;

import '../../model_class/product_attribute_model.dart';
import '../../model_class/product_model.dart';

class ProductApi{

  List<ProductModel> products = [];

  Future<void> loadProducts() async{
    var url = Uri.parse(ApiUrl.viewProducts);

    var response = await http.get(url);

    if(response.statusCode == 200){
      print(response.body);

      var jsonData = jsonDecode(response.body);

      products.clear();

      for (var item in jsonData) {
        products.add(ProductModel.fromJson(item));
      }

      for (var p in products) {
        print("Product Name: ${p.name}");

      }

    }
  }

  Future<void> loadProductsAsCategory(String? categoryId) async{
    var url = Uri.parse("${ApiUrl.viewProducts}?cat_id=$categoryId");

    var response = await http.get(url);

    if(response.statusCode == 200){
      print(response.body);

      var jsonData = jsonDecode(response.body);

      products.clear();

      for (var item in jsonData) {
        products.add(ProductModel.fromJson(item));
      }

      for (var p in products) {
        print("Product Name: ${p.name}");

      }

    }
  }

  Future<List<ProductAttributeModel>> loadProductAttributes(String productId) async {
    var url = Uri.parse("${ApiUrl.getProductAttributes}?product_id=$productId");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      List<ProductAttributeModel> attributes = [];

      if (jsonData['status'] == true && jsonData['attributes'] != null) {
        for (var attr in jsonData['attributes']) {
          attributes.add(ProductAttributeModel.fromJson(attr));
        }
      }

      return attributes;
    }

    return [];
  }

}