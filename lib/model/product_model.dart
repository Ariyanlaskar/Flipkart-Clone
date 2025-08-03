class ProductModel {
  final String id;
  final String title;
  final String imageURL;
  final double price;
  final double discount;
  final String category;

  ProductModel({
    required this.discount,
    required this.id,
    required this.imageURL,
    required this.price,
    required this.title,
    required this.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      discount: map['discount']?.toDouble() ?? 0.0,
      imageURL: map['imageURL'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
