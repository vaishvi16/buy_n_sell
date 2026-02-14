import 'package:buy_n_sell/model_class/product_attribute_model.dart';

class ProductModel {
  String? id;
  String? userId;
  String? catId;
  String? name;
  String? description;
  String? image;
  String? price;
  String? bidStatus;
  double averageRating = 0.0;
  List<ProductAttributeModel> attributes = [];

  ProductModel({
    this.id,
    this.userId,
    this.catId,
    this.name,
    this.description,
    this.image,
    this.price,
    this.bidStatus,
    this.averageRating = 0.0,
    this.attributes = const [],
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    catId = json['cat_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
    bidStatus = json['bid_status'];
    averageRating = double.tryParse(json['average_rating'].toString()) ?? 0.0;

    attributes = [];
    if (json['attributes'] != null) {
      for (var attr in json['attributes']) {
        attributes.add(ProductAttributeModel.fromJson(attr));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['cat_id'] = this.catId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['bid_status'] = this.bidStatus;
    return data;
  }
}
