class CategoryAttributeModel {
  String? id;
  String? categoryId;
  String? attributeName;
  String? attributeType;
  String? isRequired;
  List<String>? attributeOptions;

  CategoryAttributeModel({
    this.id,
    this.categoryId,
    this.attributeName,
    this.attributeType,
    this.isRequired,
    this.attributeOptions,
  });

  factory CategoryAttributeModel.fromJson(Map<String, dynamic> json) {
    return CategoryAttributeModel(
      id: json['id'],
      categoryId: json['category_id'],
      attributeName: json['attribute_name'],
      attributeType: json['attribute_type'],
      isRequired: json['is_required'],
      attributeOptions:
      json['attribute_options'] != null
          ? List<String>.from(json['attribute_options'])
          : [],
    );
  }
}