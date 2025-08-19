import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String productTitle;
  final String paymentMethod;

  const OrderSuccessScreen({
    Key? key,
    required this.productTitle,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 120),
              const SizedBox(height: 20),
              const Text(
                "Order Placed Successfully!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    const TextSpan(text: "Your order for "),
                    TextSpan(
                      text: productTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const TextSpan(text: " has been placed\nwith "),
                    TextSpan(
                      text: paymentMethod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/orders");
                },
                child: const Text(
                  "View My Orders",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false, // removes all prev routes
                  );
                },
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
