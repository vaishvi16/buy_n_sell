class CategoryModel {
  String? id;
  String? name;
  String? parentId;
  String? sellerId;
  List<String>? images;

  CategoryModel({this.id, this.name, this.parentId, this.sellerId, this.images});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    sellerId = json['seller_id'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['seller_id'] = this.sellerId;
    data['images'] = this.images;
    return data;
  }
}
