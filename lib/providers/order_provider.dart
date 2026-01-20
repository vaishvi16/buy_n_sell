import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_urls/api_urls.dart';
import '../model_class/place_order_model.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<PlaceOrderModel> placeOrder(PlaceOrderModel model) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse(ApiUrl.placeOrder),
      body: model.toMap(),
    );

    _isLoading = false;
    notifyListeners();

    final jsonResponse = jsonDecode(response.body);
    return PlaceOrderModel.fromJson(jsonResponse);
  }

}
