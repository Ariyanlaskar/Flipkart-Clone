// import 'package:flipkart_clone/features/address/riverpod_address_management.dart';
// import 'package:flipkart_clone/screens/checkout_address_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flipkart_clone/features/address/address_form_screen.dart';
// import 'package:flipkart_clone/features/address/address_model.dart';
// import 'package:flipkart_clone/model/product_model.dart';

// class CheckoutScreen extends ConsumerWidget {
//   final List<Map<String, dynamic>> cartItems;

//   const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

//   double getTotal() => cartItems.fold<double>(
//     0,
//     (sum, item) => sum + (item['product'].price * item['quantity']),
//   );

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final List<AddressModel> addresses = ref.watch(addressProvider);

//     // Pick the address marked as default, else pick the most recently added one
//     final AddressModel? selectedAddress = addresses.isNotEmpty
//         ? addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.last)
//         : null;

//     final total = getTotal();
//     final shippingCost = total > 500 ? 0.0 : 40.0;
//     final discount = total * 0.10;
//     final tax = total * 0.05;
//     final grandTotal = total - discount + shippingCost + tax;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: const Color(0xFF2874F0),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           // Progress bar
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             color: Colors.white,
//             child: LinearProgressIndicator(
//               value: 0.33,
//               backgroundColor: Colors.grey.shade300,
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                 Color(0xFF2874F0),
//               ),
//               minHeight: 6,
//             ),
//           ),

//           // Address section
//           Container(
//             color: Colors.white,
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.redAccent),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         selectedAddress != null
//                             ? "${selectedAddress.name} | ${selectedAddress.phone}"
//                             : "No address selected",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         selectedAddress != null
//                             ? selectedAddress.addressLine
//                             : "Please add your delivery address",
//                       ),
//                       const SizedBox(height: 8),
//                       OutlinedButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const CheckoutAddressScreen(),
//                             ),
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.edit_location_alt,
//                           color: Color(0xFF2874F0),
//                         ),
//                         label: Text(
//                           selectedAddress != null
//                               ? "Change / Add Address"
//                               : "Add Address",
//                           style: const TextStyle(color: Color(0xFF2874F0)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Cart Items
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               children: cartItems.map((item) {
//                 final ProductModel product = item['product'];
//                 final int quantity = item['quantity'];
//                 return ListTile(
//                   leading: Image.network(
//                     product.imageURL,
//                     width: 50,
//                     height: 50,
//                   ),
//                   title: Text(product.title),
//                   subtitle: Text("₹${product.price} x $quantity"),
//                   trailing: Text(
//                     "₹${(product.price * quantity).toStringAsFixed(0)}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Price details
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Price Details",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const Divider(),
//                 _buildPriceRow("Price", "₹${total.toStringAsFixed(0)}"),
//                 _buildPriceRow(
//                   "Discount",
//                   "-₹${discount.toStringAsFixed(0)}",
//                   isGreen: true,
//                 ),
//                 _buildPriceRow(
//                   "Shipping",
//                   shippingCost == 0 ? "Free" : "₹$shippingCost",
//                   isGreen: shippingCost == 0,
//                 ),
//                 _buildPriceRow("Tax", "₹${tax.toStringAsFixed(0)}"),
//                 const Divider(),
//                 _buildPriceRow(
//                   "Total Amount",
//                   "₹${grandTotal.toStringAsFixed(0)}",
//                   isBold: true,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),

//       // Bottom button
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           color: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "₹${grandTotal.toStringAsFixed(0)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (selectedAddress == null) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please add a delivery address'),
//                       ),
//                     );
//                     return;
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Order placed! (Mock)')),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFB641B),
//                 ),
//                 child: const Text("Place Order"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceRow(
//     String label,
//     String value, {
//     bool isGreen = false,
//     bool isBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Text(
//             value,
//             style: TextStyle(
//               color: isGreen ? Colors.green : null,
//               fontWeight: isBold ? FontWeight.bold : null,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
