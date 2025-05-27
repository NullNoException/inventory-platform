import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required String id,
    required String productId,
    required String locationId,
    required int quantity,
    int minQuantity = 0,
    int maxQuantity = 0,
    String batchNumber = '',
    DateTime? expiryDate,
    Map<String, dynamic> additionalAttributes = const {},
    required DateTime createdAt,
    required DateTime updatedAt,
    required String lastUpdatedBy,
  }) : super(
         id: id,
         productId: productId,
         locationId: locationId,
         quantity: quantity,
         minQuantity: minQuantity,
         maxQuantity: maxQuantity,
         batchNumber: batchNumber,
         expiryDate: expiryDate,
         additionalAttributes: additionalAttributes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         lastUpdatedBy: lastUpdatedBy,
       );

  // Convert from JSON (from Appwrite document)
  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['\$id'] ?? '',
      productId: json['productId'] ?? '',
      locationId: json['locationId'] ?? '',
      quantity: json['quantity'] ?? 0,
      minQuantity: json['minQuantity'] ?? 0,
      maxQuantity: json['maxQuantity'] ?? 0,
      batchNumber: json['batchNumber'] ?? '',
      expiryDate:
          json['expiryDate'] != null
              ? DateTime.parse(json['expiryDate'])
              : null,
      additionalAttributes: json['additionalAttributes'] ?? {},
      createdAt:
          json['\$createdAt'] != null
              ? DateTime.parse(json['\$createdAt'])
              : DateTime.now(),
      updatedAt:
          json['\$updatedAt'] != null
              ? DateTime.parse(json['\$updatedAt'])
              : DateTime.now(),
      lastUpdatedBy: json['lastUpdatedBy'] ?? '',
    );
  }

  // Convert to JSON (for Appwrite document)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'locationId': locationId,
      'quantity': quantity,
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.toIso8601String(),
      'additionalAttributes': additionalAttributes,
      'lastUpdatedBy': lastUpdatedBy,
    };
  }

  // Create a copy with modified fields (override for proper typing)
  @override
  InventoryItemModel copyWith({
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
    return InventoryItemModel(
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
