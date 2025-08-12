// lib/repositories/address_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_clone/features/address/address_model.dart';

class AddressRepository {
  final FirebaseFirestore _firestore;

  AddressRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _addressesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('addresses');
  }

  Future<List<AddressModel>> fetchAddresses(String uid) async {
    final snap = await _addressesRef(
      uid,
    ).orderBy('isDefault', descending: true).get();
    return snap.docs.map((d) => AddressModel.fromMap(d.data(), d.id)).toList();
  }

  Stream<List<AddressModel>> watchAddresses(String uid) {
    return _addressesRef(uid)
        .orderBy('isDefault', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AddressModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  Future<String> addAddress(String uid, AddressModel address) async {
    final docRef = _addressesRef(uid).doc();
    // If adding as default, ensure others are unset
    if (address.isDefault) {
      await _unsetAllDefaults(uid);
    }
    await docRef.set(address.copyWith(id: docRef.id).toMap());
    // also set parent defaultAddress pointer to this id if isDefault
    if (address.isDefault) {
      await _setUserDefaultAddress(uid, docRef.id);
    }
    return docRef.id;
  }

  Future<void> updateAddress(String uid, AddressModel address) async {
    final docRef = _addressesRef(uid).doc(address.id);
    if (address.isDefault) {
      await _unsetAllDefaults(uid);
      await _setUserDefaultAddress(uid, address.id);
    }
    await docRef.update(address.toMap());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    final ref = _addressesRef(uid).doc(addressId);
    // if deleting default, you might want to clear user's defaultAddress pointer
    final doc = await ref.get();
    final wasDefault = doc.exists && (doc.data()?['isDefault'] == true);
    await ref.delete();
    if (wasDefault) {
      await _clearUserDefaultAddress(uid);
    }
  }

  Future<void> setDefaultAddress(String uid, String addressId) async {
    await _unsetAllDefaults(uid);
    await _addressesRef(uid).doc(addressId).update({'isDefault': true});
    await _setUserDefaultAddress(uid, addressId);
  }

  // helpers
  Future<void> _unsetAllDefaults(String uid) async {
    final snap = await _addressesRef(
      uid,
    ).where('isDefault', isEqualTo: true).get();
    final batch = _firestore.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {'isDefault': false});
    }
    await batch.commit();
  }

  Future<void> _setUserDefaultAddress(String uid, String addressId) async {
    await _firestore.collection('users').doc(uid).update({
      'defaultAddress': addressId,
    });
  }

  Future<void> _clearUserDefaultAddress(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'defaultAddress': FieldValue.delete(),
    });
  }
}
