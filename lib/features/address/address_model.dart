import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String pinCode;
  final String locality;
  final String landmark;
  final String city;
  final String state;
  final String type; // Home / Work / Other
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.pinCode,
    required this.locality,
    required this.landmark,
    required this.city,
    required this.state,
    required this.type,
    this.isDefault = false,
  });

  /// Create from map + doc id
  factory AddressModel.fromMap(Map<String, dynamic> map, String id) {
    return AddressModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      pinCode: map['pinCode'] ?? '',
      locality: map['locality'] ?? '',
      landmark: map['landmark'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      type: map['type'] ?? 'Home',
      isDefault: map['isDefault'] == true,
    );
  }

  /// Convenience: create directly from a DocumentSnapshot
  factory AddressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return AddressModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'pinCode': pinCode,
      'locality': locality,
      'landmark': landmark,
      'city': city,
      'state': state,
      'type': type,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? pinCode,
    String? locality,
    String? landmark,
    String? city,
    String? state,
    String? type,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      pinCode: pinCode ?? this.pinCode,
      locality: locality ?? this.locality,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      state: state ?? this.state,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// small helper used in UI
  String get fullSummary => '$locality, $city - $pinCode';
}
