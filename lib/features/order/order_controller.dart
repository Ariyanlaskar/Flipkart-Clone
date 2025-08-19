import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_repo.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final orderControllerProvider =
    StateNotifierProvider<OrderController, AsyncValue<void>>((ref) {
      return OrderController(ref.watch(orderRepositoryProvider));
    });

class OrderController extends StateNotifier<AsyncValue<void>> {
  final OrderRepository _repo;

  OrderController(this._repo) : super(const AsyncValue.data(null));

  Future<void> placeOrder({
    required String productId,
    required String title,
    required String imageURL,
    required double price,
    required int quantity,
    required String paymentMethod,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.placeOrder(
        productId: productId,
        title: title,
        imageURL: imageURL,
        price: price,
        quantity: quantity,
        paymentMethod: paymentMethod,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
