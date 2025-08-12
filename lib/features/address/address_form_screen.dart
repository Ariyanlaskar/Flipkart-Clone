// import 'package:flipkart_clone/features/address/riverpod_address_management.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flipkart_clone/features/address/address_model.dart';

// class AddressFormScreen extends ConsumerStatefulWidget {
//   const AddressFormScreen({super.key});

//   @override
//   ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
// }

// class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   void _saveAddress() {
//     if (_formKey.currentState!.validate()) {
//       final address = AddressModel(
//         name: _nameController.text,
//         phone: _phoneController.text,
//         addressLine: _addressController.text, id: '', pinCode: '', locality: '', landmark: '', city: '', state: '', type: '',
//       );

//       // Save in Riverpod provider
//       ref.read(addressProvider.notifier).addAddress(address);

//       Navigator.pop(context); // Close screen
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final addresses = ref.watch(addressProvider);
//     final selectedAddress = addresses.isNotEmpty
//         ? addresses.firstWhere(
//             (a) => a.isDefault,
//             orElse: () => addresses.first,
//           )
//         : null;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Address")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Existing addresses list
//               if (addresses.isNotEmpty) ...[
//                 const Text(
//                   "Select an existing address",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 ...addresses.map((address) {
//                   return RadioListTile<String>(
//                     value: address.id,
//                     groupValue: selectedAddress?.id,
//                     onChanged: (id) {
//                       ref.read(addressProvider.notifier).setDefaultAddress(id!);
//                     },
//                     title: Text("${address.name} | ${address.phone}"),
//                     subtitle: Text(address.addressLine),
//                   );
//                 }).toList(),
//                 const Divider(height: 32),
//               ],

//               // New address form
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: const InputDecoration(labelText: "Name"),
//                       validator: (value) =>
//                           value!.isEmpty ? "Enter your name" : null,
//                     ),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: const InputDecoration(labelText: "Phone"),
//                       validator: (value) =>
//                           value!.isEmpty ? "Enter phone number" : null,
//                     ),
//                     TextFormField(
//                       controller: _addressController,
//                       decoration: const InputDecoration(labelText: "Address"),
//                       validator: (value) =>
//                           value!.isEmpty ? "Enter address" : null,
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _saveAddress,
//                       child: const Text("Save Address"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
