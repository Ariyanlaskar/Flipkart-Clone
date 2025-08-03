import 'package:flipkart_clone/model/product_model.dart';

class PaginatedProductState {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasMore;

  PaginatedProductState({
    required this.products,
    required this.isLoading,
    required this.hasMore,
  });

  PaginatedProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? hasMore,
  }) {
    return PaginatedProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory PaginatedProductState.initial() {
    return PaginatedProductState(products: [], isLoading: false, hasMore: true);
  }
}
