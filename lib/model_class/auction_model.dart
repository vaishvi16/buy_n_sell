class AuctionProductModel {
  final String id;
  final String name;
  final String image;
  final String price;
  final String bidStatus;

  AuctionProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.bidStatus,
  });

  factory AuctionProductModel.fromJson(Map<String, dynamic> json) {
    return AuctionProductModel(
      id: json['id'].toString(),
      name: json['name'],
      image: json['image'],
      price: json['price'].toString(),
      bidStatus: json['bid_status'],
    );
  }
}
