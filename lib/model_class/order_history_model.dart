class OrderItemModel {
  final String productId;
  final String quantity;
  final String name;
  final String price;
  final String image;

  OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.name,
    required this.price,
    required this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? '0',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
    );
  }
}


class OrderHistoryModel {
  final String id;
  final String orderStatus;
  final String shippingType;
  final String orderTime;
  final List<OrderItemModel> items;

  OrderHistoryModel({
    required this.id,
    required this.orderStatus,
    required this.shippingType,
    required this.orderTime,
    required this.items,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id'] ?? '',
      orderStatus: json['order_status'] ?? '',
      shippingType: json['shipping_type'] ?? '',
      orderTime: json['order_time'] ?? '',
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}
