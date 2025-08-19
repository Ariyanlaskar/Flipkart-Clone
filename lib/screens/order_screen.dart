import 'package:flipkart_clone/features/order/order_controller.dart';
import 'package:flipkart_clone/features/order/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(orderRepositoryProvider).getOrders();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: screenWidth * 0.25,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Orders Yet",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Place your first order to see it here",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order.imageURL,
                          height: screenWidth * 0.22,
                          width: screenWidth * 0.22,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Order Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              order.title,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Price
                            Text(
                              "₹${order.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Payment Method
                            Text(
                              "Payment: ${order.paymentMethod}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Order Date
                            Text(
                              "Ordered on: ${order.orderedAt.day}-${order.orderedAt.month}-${order.orderedAt.year}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Status Button (like Flipkart)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: Text(
                                "Order Placed",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
