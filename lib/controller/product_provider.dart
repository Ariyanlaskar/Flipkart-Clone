import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/repo/pagination_prod_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/model/product_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .get();

  return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
});
final allProductsByCategoryProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, category) async {
      final firestore = FirebaseFirestore.instance;

      // 1. Fetch from top-level 'products'
      final topLevelSnapshot = await firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      final topLevelProducts = topLevelSnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();

      // 2. Fetch from all 'DealsOfTheDay' subcollections
      final dealsSnapshot = await firestore
          .collectionGroup('DealsOfTheDay')
          .where('category', isEqualTo: category)
          .get();

      final dealProducts = dealsSnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();
      final test = await FirebaseFirestore.instance
          .collectionGroup('DealsOfTheDay')
          .get();

      for (var doc in test.docs) {
        print("📦 Document ID: ${doc.id} | category: ${doc['category']}");
      }

      // 3. Combine and return
      return [...topLevelProducts, ...dealProducts];
    });

// This wil fetch our deal of the day section data from firebase
final dealOfTheDayProvider = FutureProvider<List<ProductModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collectionGroup('DealsOfTheDay') // 🔥 This queries across all paths
      .get();

  return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
});

// This is for product pagination which will enable lazy loading

class PaginatedProductNotifier extends StateNotifier<PaginatedProductState> {
  final Ref ref;
  final String? category;
  DocumentSnapshot? _lastDoc;
  final int _limit = 4;

  PaginatedProductNotifier(this.ref, this.category)
    : super(PaginatedProductState.initial()) {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    _lastDoc = null;
    state = PaginatedProductState.initial();
    await fetchNext();
  }

  Future<void> fetchNext() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      Query query = FirebaseFirestore.instance.collection('products');
      if (category != null && category != 'ALL') {
        query = query.where('category', isEqualTo: category);
      }

      query = query.orderBy('title').limit(_limit);

      if (_lastDoc != null) {
        query = query.startAfterDocument(_lastDoc!);
      }

      final snapshot = await query.get();

      final newProducts = snapshot.docs
          .map(
            (doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();

      final allProducts = [...state.products, ...newProducts];

      _lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : _lastDoc;

      state = state.copyWith(
        products: allProducts,
        isLoading: false,
        hasMore: newProducts.length >= _limit,
      );
    } catch (e) {
      print("Pagination error: $e");
      state = state.copyWith(isLoading: false, hasMore: false);
    }
  }
}

final paginatedProductsProvider =
    StateNotifierProvider.family<
      PaginatedProductNotifier,
      PaginatedProductState,
      String
    >((ref, category) => PaginatedProductNotifier(ref, category));
