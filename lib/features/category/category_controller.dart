import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/features/category/category_sc_repo.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepoProvider = Provider((ref) => CategoryRepository());
final selectedCategoryProvider = StateProvider<String>((ref) => 'Mobiles');

final categoryProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, category) {
      final firestore = FirebaseFirestore.instance;

      return firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ProductModel.fromMap({
                'id': doc.id, // include document ID
                ...data,
              });
            }).toList();
          });
    });
