import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final String id;
  final String productId;
  final String locationId;
  final int quantity;
  final int minQuantity; // Minimum stock level for alerts
  final int maxQuantity; // Maximum stock level for storage planning
  final String batchNumber; // For batch tracking
  final DateTime? expiryDate; // For expiry tracking
  final Map<String, dynamic>
  additionalAttributes; // For custom inventory attributes
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastUpdatedBy;

  const InventoryItem({
    required this.id,
    required this.productId,
    required this.locationId,
    required this.quantity,
    this.minQuantity = 0,
    this.maxQuantity = 0,
    this.batchNumber = '',
    this.expiryDate,
    this.additionalAttributes = const {},
    required this.createdAt,
    required this.updatedAt,
    required this.lastUpdatedBy,
  });

  bool get isLowStock => quantity <= minQuantity;
  bool get isOverStocked => maxQuantity > 0 && quantity >= maxQuantity;
  bool get hasExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysToExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysToExpiry > 0 && daysToExpiry <= 30; // Consider "soon" as 30 days
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    locationId,
    quantity,
    minQuantity,
    maxQuantity,
    batchNumber,
    expiryDate,
    additionalAttributes,
    createdAt,
    updatedAt,
    lastUpdatedBy,
  ];

  // Create a copy with modified fields
  InventoryItem copyWith({
    String? id,
    String? productId,
    String? locationId,
    int? quantity,
    int? minQuantity,
    int? maxQuantity,
    String? batchNumber,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
    Map<String, dynamic>? additionalAttributes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? lastUpdatedBy,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      locationId: locationId ?? this.locationId,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }
}
