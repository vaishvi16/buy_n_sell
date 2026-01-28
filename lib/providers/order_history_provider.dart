import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_urls/api_urls.dart';
import '../model_class/order_history_model.dart';
import '../shared_pref/shared_pref.dart';

class OrderHistoryProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<OrderHistoryModel> orders = [];

  Future<void> fetchOrders() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final userId = await SharedPref.getUserId();
      if (userId == null) {
        errorMessage = "User not logged in";
        isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiUrl.getOrder}?user_id=$userId"),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        orders = (data['orders'] as List)
            .map((e) => OrderHistoryModel.fromJson(e))
            .toList();
      } else {
        errorMessage = data['message'];
      }
    } catch (e) {
      errorMessage = "Something went wrong";
    }

    isLoading = false;
    notifyListeners();
  }
}
