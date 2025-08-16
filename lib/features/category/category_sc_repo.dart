import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProductsBySubcategory(
    String subcategory,
  ) async {
    final snapshot = await _firestore
        .collection('products')
        .where('subcategory', isEqualTo: subcategory)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getProductsFromMultipleCategories(
    List<String> categories,
  ) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', whereIn: categories)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
