import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String code;
  final String type; // warehouse, store, supplier, etc.
  final String address;
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;
  final bool isActive;
  final Map<String, dynamic> attributes; // For custom location attributes
  final DateTime createdAt;
  final DateTime updatedAt;

  const Location({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.address = '',
    this.contactPerson = '',
    this.contactPhone = '',
    this.contactEmail = '',
    this.isActive = true,
    this.attributes = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    type,
    address,
    contactPerson,
    contactPhone,
    contactEmail,
    isActive,
    attributes,
    createdAt,
    updatedAt,
  ];

  // Create a copy with modified fields
  Location copyWith({
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
    return Location(
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
