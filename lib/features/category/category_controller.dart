import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/features/category/category_sc_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepoProvider = Provider((ref) => CategoryRepository());
final selectedCategoryProvider = StateProvider<String>((ref) => 'For You');

final categoryProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, category) {
      final firestore = FirebaseFirestore.instance;

      Query query = firestore.collection('products');

      if (category == 'Electronics') {
        // fetch both Electronics and Mobiles
        query = query.where(
          'category',
          whereIn: [
            'Electronics',
            'Mobiles',
            'Laptops',
            'Speakers',
            'Accessories',
          ],
        );
      } else if (category == "For You") {
        query = query.where(
          'category',
          whereIn: ['Electronics', 'Mobiles', 'Accessories', 'Sports'],
        );
      } else if (category == "Smart Gadgets") {
        query = query.where('category', whereIn: ['Accessories', 'Speakers']);
      } else {
        // normal single category
        query = query.where('category', isEqualTo: category);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ProductModel.fromMap({
            'id': doc.id, // include document ID
            ...data,
          });
        }).toList();
      });
    });
