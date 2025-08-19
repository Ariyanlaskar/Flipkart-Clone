import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/features/cart/cart_model.dart';
import 'package:flipkart_clone/features/cart/cart_repo.dart';
import 'package:flipkart_clone/repo/pagination_prod_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/model/product_model.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

//Implementing search functionlaity(retrieve search history,search by words)

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .get();

  // Client-side filtering for now (Firestore doesn't support 'contains' natively)
  return snapshot.docs
      .map((doc) => ProductModel.fromMap(doc.data()))
      .where(
        (product) => product.title.toLowerCase().contains(query.toLowerCase()),
      )
      .toList();
});

/// Holds the currently selected category (null means nothing selected)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

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
      .collectionGroup('DealsOfTheDay') // This queries across all paths
      .get();

  return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList();
});

// This is for product pagination which will enable lazy loading
// For lazyloading feature
class PaginatedProductNotifier extends StateNotifier<PaginatedProductState> {
  final Ref ref;
  final String? category;
  DocumentSnapshot? _lastDoc;
  final int _limit = 10;

  PaginatedProductNotifier(this.ref, this.category)
    : super(PaginatedProductState.initial()) {
    Future.microtask(() => fetchInitial());
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

// For splash screen

final splashControllerProvider = FutureProvider<void>((ref) async {
  // Wait for Firebase and auth state to resolve

  // Optionally wait for critical data too:
  // await ref.read(paginatedProductsProvider('ALL').notifier).fetchInitial();

  await Future.delayed(
    const Duration(milliseconds: 3000),
  ); // slight delay to show splash
});

//For Add to Cart functionality

final cartRepositoryProvider = Provider((ref) => CartRepo());

final cartItemsProvider = StreamProvider<List<CartItem>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty(); // No cart if not logged in

  return ref.watch(cartRepositoryProvider).getCartItems(user.uid);
});

class CartItemsNotifier extends StateNotifier<List<ProductModel>> {
  CartItemsNotifier() : super([]);

  void addItem(ProductModel item) {
    state = [...state, item];
  }

  void removeItem(ProductModel item) {
    state = state.where((e) => e != item).toList();
  }

  void clearCart() {
    state = [];
  }
}

// final cartItemsProvider =
//     StateNotifierProvider<CartItemsNotifier, List<ProductModel>>(
//         (ref) => CartItemsNotifier());
