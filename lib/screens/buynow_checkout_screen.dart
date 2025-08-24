import 'package:flipkart_clone/screens/order_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/features/order/order_controller.dart';
import 'package:flipkart_clone/model/product_model.dart';

final selectedPaymentProvider = StateProvider<String?>((ref) => null);

class CheckoutScreen extends ConsumerWidget {
  final ProductModel product;

  const CheckoutScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final selectedPayment = ref.watch(selectedPaymentProvider);

    double itemTotal = product.price;
    double discountAmount = (product.price * product.discount) / 100;
    double totalAmount = itemTotal - discountAmount;

    final paymentOptions = [
      {"title": "UPI", "subtitle": "Google Pay, PhonePe, Paytm & more"},
      {
        "title": "Credit / Debit Card",
        "subtitle": "Visa, MasterCard, RuPay, etc.",
      },
      {"title": "Net Banking", "subtitle": "All major banks supported"},
      {
        "title": "Cash on Delivery",
        "subtitle": "Pay when you receive the order",
      },
      {"title": "Wallets", "subtitle": "Paytm, PhonePe Wallet & more"},
    ];

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Deliver to: Ariyan Laskar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Dummy Address, Pune, Maharashtra - 411001",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Phone: 7002508034",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Change",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Product Details Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Image.network(
                    product.imageURL,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text("₹${product.price.toStringAsFixed(0)}"),
                  trailing: Text(
                    "${product.discount.toStringAsFixed(0)}% OFF",
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Order Summary
              Text(
                "Order Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width < 400 ? 15 : 16,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      summaryRow(
                        "Item Total",
                        "₹${itemTotal.toStringAsFixed(0)}",
                      ),
                      summaryRow(
                        "Discount",
                        "-₹${discountAmount.toStringAsFixed(0)}",
                        color: Colors.green,
                      ),
                      summaryRow(
                        "Delivery Charges",
                        "Free",
                        color: Colors.green,
                      ),
                      const Divider(),
                      summaryRow(
                        "Total Amount",
                        "₹${totalAmount.toStringAsFixed(0)}",
                        isBold: true,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Payment Options
              Text(
                "Payment Options",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width < 400 ? 15 : 16,
                ),
              ),
              const SizedBox(height: 8),
              ...paymentOptions.map((option) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile<String>(
                    value: option["title"]!,
                    groupValue: selectedPayment,
                    activeColor: Colors.blue,
                    title: Text(
                      option["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(option["subtitle"]!),
                    onChanged: (val) {
                      ref.read(selectedPaymentProvider.notifier).state = val;
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 70),
            ],
          ),
        ),

        // Buy Now Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: selectedPayment == null
                ? null
                : () async {
                    await ref
                        .read(orderControllerProvider.notifier)
                        .placeOrder(
                          productId: product.id,
                          title: product.title,
                          imageURL: product.imageURL,
                          price: product.price,
                          quantity: 1,
                          paymentMethod: selectedPayment!,
                        );

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       "Order placed for ${product.title} with $selectedPayment!",
                    //     ),
                    //   ),
                    // );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderSuccessScreen(
                          productTitle: product.title,
                          paymentMethod: selectedPayment,
                        ),
                      ),
                    );

                    // Navigator.pushNamed(context, '/orders');
                  },
            child: const Text(
              "Place Order",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryRow(
    String title,
    String value, {
    bool isBold = false,
    double fontSize = 14,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
