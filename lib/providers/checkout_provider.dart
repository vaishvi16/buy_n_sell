import 'package:flutter/material.dart';
import '../model_class/place_order_model.dart';

class CheckoutProvider extends ChangeNotifier {
  // PAYMENT
  String? _paymentMethod;
  String? get paymentMethod => _paymentMethod;

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // SHIPPING
  int _shippingIndex = 0;
  double _shippingPrice = 0;

  int get shippingIndex => _shippingIndex;
  double get shippingPrice => _shippingPrice;

  void setShipping(int index) {
    _shippingIndex = index;
    _shippingPrice = index == 0 ? 0 : 700;
    notifyListeners();
  }

  String get shippingType =>
      _shippingIndex == 0 ? "standard" : "express";

  // ADDRESS & CONTACT
  String? _address;
  String? _phone;
  String? _email;

  String? get address => _address;
  String? get phone => _phone;
  String? get email => _email;

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setContact({String? phone, String? email}) {
    _phone = phone;
    _email = email;
    notifyListeners();
  }

  // VALIDATION
  String? validate() {
    if (_address == null || _address!.isEmpty) {
      return "Please add shipping address";
    }
    if (_phone == null || _phone!.isEmpty) {
      return "Please add phone number";
    }
    if (_paymentMethod == null) {
      return "Please select payment method";
    }
    return null;
  }

  // BUILD ORDER MODEL
  PlaceOrderModel buildOrder({
    required String userId,
    required String productIds,
    required Map<String, int> quantities,
    required double totalAmount,
  }) {
    return PlaceOrderModel(
      userId: userId,
      productIds: productIds,
      quantities: quantities,
      address: _address,
      phone: _phone,
      paymentMethod: _paymentMethod,
      shippingType: shippingType,
      totalAmount: totalAmount,
    );
  }

  void reset() {
    _paymentMethod = null;
    _shippingIndex = 0;
    _shippingPrice = 0;
    notifyListeners();
  }
}
