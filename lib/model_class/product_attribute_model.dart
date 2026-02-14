class ProductAttributeModel {
  String? attributeName;
  String? attributeValue;

  ProductAttributeModel({this.attributeName, this.attributeValue});

  ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    attributeName = json['attribute_name'];
    attributeValue = json['attribute_value'];
  }
}
