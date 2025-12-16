import 'dart:convert';

import 'package:buy_n_sell/api_urls/api_urls.dart';
import 'package:http/http.dart' as http;

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

}