import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipkart_clone/model/product_model.dart';
import 'package:flutter/material.dart';

class BuyNowCheckoutScreen extends StatefulWidget {
  final ProductModel productData;
  final bool isFromCart;

  const BuyNowCheckoutScreen({
    super.key,
    required this.productData,
    this.isFromCart = false,
  });

  @override
  State<BuyNowCheckoutScreen> createState() => _BuyNowCheckoutScreenState();
}

class _BuyNowCheckoutScreenState extends State<BuyNowCheckoutScreen> {
  String? address;
  String? selectedAddressId;
  bool isLoading = false;
  bool isAddressLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDefaultAddress();
  }

  Future<void> _fetchDefaultAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data()?['defaultAddress'] != null) {
        final addressId = userDoc['defaultAddress'];
        final addressDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .doc(addressId)
            .get();

        if (addressDoc.exists) {
          setState(() {
            address = addressDoc['fullAddress'];
            selectedAddressId = addressId;
          });
        }
      }
    }
    setState(() => isAddressLoading = false);
  }

  Future<void> _selectAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ...snapshot.docs.map((doc) {
                return ListTile(
                  title: Text(doc['fullAddress']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await doc.reference.delete();
                      if (selectedAddressId == doc.id) {
                        setState(() {
                          address = null;
                          selectedAddressId = null;
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({'defaultAddress': doc.id});
                    setState(() {
                      address = doc['fullAddress'];
                      selectedAddressId = doc.id;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              ListTile(
                leading: const Icon(Icons.add_location_alt, color: Colors.blue),
                title: const Text("Add New Address"),
                onTap: () {
                  Navigator.pop(context);
                  _addNewAddress();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addNewAddress() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String newAddress = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Address"),
        content: TextField(
          decoration: const InputDecoration(hintText: "Enter full address"),
          onChanged: (value) => newAddress = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newAddress.trim().isNotEmpty) {
                final addressRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('addresses')
                    .doc();
                await addressRef.set({'fullAddress': newAddress.trim()});
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'defaultAddress': addressRef.id});
                setState(() {
                  address = newAddress.trim();
                  selectedAddressId = addressRef.id;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || selectedAddressId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select an address")));
      return;
    }

    setState(() => isLoading = true);

    final orderId = FirebaseFirestore.instance.collection('orders').doc().id;
    final orderData = {
      'orderId': orderId,
      'userId': uid,
      'products': [widget.productData],
      'totalAmount': widget.productData.price,
      'address': address,
      'status': 'Pending',
      'placedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(orderData);

    if (widget.isFromCart) {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart');
      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Address",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectAddress,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 16 : 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isAddressLoading
                          ? const Text("Loading address...")
                          : Text(address ?? "Tap to select address"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Order Summary",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.network(
                        widget.productData.imageURL,
                        width: isTablet ? 120 : 80,
                        height: isTablet ? 120 : 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.productData.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "₹${widget.productData.price}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 18 : 14,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
