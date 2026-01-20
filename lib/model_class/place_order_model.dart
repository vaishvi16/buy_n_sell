import 'dart:convert';

class PlaceOrderModel {
  // -------- REQUEST FIELDS --------
  String? userId;
  String? productIds;
  Map<String, int>? quantities;
  String? address;
  String? phone;
  String? paymentMethod;
  String? shippingType;
  double? totalAmount;

  // -------- RESPONSE FIELDS --------
  String? status;
  String? message;
  int? orderId;

  PlaceOrderModel({
    this.userId,
    this.productIds,
    this.quantities,
    this.address,
    this.phone,
    this.paymentMethod,
    this.shippingType,
    this.totalAmount,
    this.status,
    this.message,
    this.orderId,
  });

  // SEND TO API
  Map<String, String> toMap() {
    return {
      "user_id": userId ?? '',
      "product_ids": productIds ?? '',
      "quantities": jsonEncode(quantities ?? {}),
      "address": address ?? '',
      "phone": phone ?? '',
      "payment_method": paymentMethod ?? '',
      "shipping_type": shippingType ?? '',
      "total_amount": totalAmount?.toString() ?? '0',
    };
  }

  // READ FROM API
  factory PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderModel(
      status: json['status'],
      message: json['message'],
      orderId: json['order_id'] != null
          ? int.tryParse(json['order_id'].toString())
          : null,
    );
  }
}
