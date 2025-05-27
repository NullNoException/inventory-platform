import 'package:inventory_app/features/inventory/domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required String id,
    required String name,
    required String code,
    required String type,
    String address = '',
    String contactPerson = '',
    String contactPhone = '',
    String contactEmail = '',
    bool isActive = true,
    Map<String, dynamic> attributes = const {},
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         name: name,
         code: code,
         type: type,
         address: address,
         contactPerson: contactPerson,
         contactPhone: contactPhone,
         contactEmail: contactEmail,
         isActive: isActive,
         attributes: attributes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  // Convert from JSON (from Appwrite document)
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['\$id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      isActive: json['isActive'] ?? true,
      attributes: json['attributes'] ?? {},
      createdAt:
          json['\$createdAt'] != null
              ? DateTime.parse(json['\$createdAt'])
              : DateTime.now(),
      updatedAt:
          json['\$updatedAt'] != null
              ? DateTime.parse(json['\$updatedAt'])
              : DateTime.now(),
    );
  }

  // Convert to JSON (for Appwrite document)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'type': type,
      'address': address,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'isActive': isActive,
      'attributes': attributes,
    };
  }

  // Create a copy with modified fields (override for proper typing)
  @override
  LocationModel copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? address,
    String? contactPerson,
    String? contactPhone,
    String? contactEmail,
    bool? isActive,
    Map<String, dynamic>? attributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      address: address ?? this.address,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      isActive: isActive ?? this.isActive,
      attributes: attributes ?? this.attributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
