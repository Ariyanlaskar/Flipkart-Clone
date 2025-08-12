import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_clone/features/address/address_model.dart';
import 'package:uuid/uuid.dart';

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super([]);

  final _uuid = const Uuid();

  // Add a new address and make it default
  void addAddress(AddressModel address) {
    // Remove default from all existing
    final updatedList = state.map((a) => a.copyWith(isDefault: false)).toList();

    // Add new as default
    final newAddress = address.copyWith(id: _uuid.v4(), isDefault: true);

    state = [...updatedList, newAddress];
  }

  // Change default address
  void setDefaultAddress(String id) {
    state = state.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
  }

  // Remove an address
  void removeAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  // Edit an address (keeps same id)
  void updateAddress(AddressModel updated) {
    state = state.map((a) {
      return a.id == updated.id ? updated : a;
    }).toList();
  }

  // Clear all addresses
  void clearAll() {
    state = [];
  }
}

final addressProvider =
    StateNotifierProvider<AddressNotifier, List<AddressModel>>(
      (ref) => AddressNotifier(),
    );
