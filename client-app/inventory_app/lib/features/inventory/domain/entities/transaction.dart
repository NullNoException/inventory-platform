import 'package:equatable/equatable.dart';

enum TransactionType {
  purchase,
  sale,
  transfer,
  adjustment,
  stockTake,
  return_,
  other,
}

class Transaction extends Equatable {
  final String id;
  final String productId;
  final String
  sourceLocationId; // Where the product came from (null for purchases)
  final String
  destinationLocationId; // Where the product went to (null for sales)
  final int quantity;
  final TransactionType type;
  final String referenceNumber; // PO number, invoice number, etc.
  final String notes;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final Map<String, dynamic> additionalAttributes;

  const Transaction({
    required this.id,
    required this.productId,
    required this.sourceLocationId,
    required this.destinationLocationId,
    required this.quantity,
    required this.type,
    this.referenceNumber = '',
    this.notes = '',
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.additionalAttributes = const {},
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    sourceLocationId,
    destinationLocationId,
    quantity,
    type,
    referenceNumber,
    notes,
    transactionDate,
    createdAt,
    updatedAt,
    createdBy,
    additionalAttributes,
  ];

  // Create a copy with modified fields
  Transaction copyWith({
    String? id,
    String? productId,
    String? sourceLocationId,
    String? destinationLocationId,
    int? quantity,
    TransactionType? type,
    String? referenceNumber,
    String? notes,
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? additionalAttributes,
  }) {
    return Transaction(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sourceLocationId: sourceLocationId ?? this.sourceLocationId,
      destinationLocationId:
          destinationLocationId ?? this.destinationLocationId,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
    );
  }
}
