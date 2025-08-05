class ProductModel {
  final String id;
  final String title;
  final String imageURL;
  final double price;
  final double discount;
  final String category;
  final double mrp;
  final double rating;
  final int reviews;
  final List<String> offers;
  final String specifications;

  ProductModel({
    required this.id,
    required this.title,
    required this.imageURL,
    required this.price,
    required this.discount,
    required this.category,
    required this.mrp,
    required this.rating,
    required this.reviews,
    required this.offers,
    required this.specifications,
  });

  // Getter to simulate images list from single imageURL
  List<String> get images => [imageURL];

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      imageURL: map['imageURL']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      category: map['category']?.toString() ?? '',
      mrp: (map['mrp'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      reviews: (map['reviews'] ?? 0),
      offers: List<String>.from(map['offers'] ?? []),
      specifications: map['specifications']?.toString() ?? '',
    );
  }
}
