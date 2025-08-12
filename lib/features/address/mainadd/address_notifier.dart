// lib/providers/address_notifier.dart
import 'package:flipkart_clone/features/address/address_model.dart';
import 'package:flipkart_clone/features/address/mainadd/address_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// provide repository (override in tests if needed)
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(firestore: FirebaseFirestore.instance);
});

// address stream provider from repository
final addressesStreamProvider = StreamProvider.autoDispose<List<AddressModel>>((
  ref,
) {
  final repo = ref.watch(addressRepositoryProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return const Stream.empty();
  }
  return repo.watchAddresses(uid);
});

// notifier for imperatively adding/updating/deleting
final addressActionProvider = Provider((ref) {
  final repo = ref.read(addressRepositoryProvider);
  return AddressActions(repo, ref);
});

class AddressActions {
  final AddressRepository _repo;
  final ProviderRef _ref;
  AddressActions(this._repo, this._ref);

  Future<String?> add(AddressModel address) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final id = await _repo.addAddress(uid, address);
    return id;
  }

  Future<void> update(AddressModel address) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _repo.updateAddress(uid, address);
  }

  Future<void> delete(String addressId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _repo.deleteAddress(uid, addressId);
  }

  Future<void> setDefault(String addressId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _repo.setDefaultAddress(uid, addressId);
  }

  Future<List<AddressModel>> fetchAllOnce() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    return _repo.fetchAddresses(uid);
  }
}
