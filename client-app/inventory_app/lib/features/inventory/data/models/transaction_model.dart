import 'package:inventory_app/features/inventory/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required String id,
    required String productId,
    required String sourceLocationId,
    required String destinationLocationId,
    required int quantity,
    required TransactionType type,
    String referenceNumber = '',
    String notes = '',
    required DateTime transactionDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
    Map<String, dynamic> additionalAttributes = const {},
  }) : super(
         id: id,
         productId: productId,
         sourceLocationId: sourceLocationId,
         destinationLocationId: destinationLocationId,
         quantity: quantity,
         type: type,
         referenceNumber: referenceNumber,
         notes: notes,
         transactionDate: transactionDate,
         createdAt: createdAt,
         updatedAt: updatedAt,
         createdBy: createdBy,
         additionalAttributes: additionalAttributes,
       );

  // Convert from JSON (from Appwrite document)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['\$id'] ?? '',
      productId: json['productId'] ?? '',
      sourceLocationId: json['sourceLocationId'] ?? '',
      destinationLocationId: json['destinationLocationId'] ?? '',
      quantity: json['quantity'] ?? 0,
      type: _parseTransactionType(json['type']),
      referenceNumber: json['referenceNumber'] ?? '',
      notes: json['notes'] ?? '',
      transactionDate:
          json['transactionDate'] != null
              ? DateTime.parse(json['transactionDate'])
              : DateTime.now(),
      createdAt:
          json['\$createdAt'] != null
              ? DateTime.parse(json['\$createdAt'])
              : DateTime.now(),
      updatedAt:
          json['\$updatedAt'] != null
              ? DateTime.parse(json['\$updatedAt'])
              : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      additionalAttributes: json['additionalAttributes'] ?? {},
    );
  }

  // Helper method to parse TransactionType enum from string
  static TransactionType _parseTransactionType(String? typeString) {
    if (typeString == null) return TransactionType.other;

    switch (typeString) {
      case 'purchase':
        return TransactionType.purchase;
      case 'sale':
        return TransactionType.sale;
      case 'transfer':
        return TransactionType.transfer;
      case 'adjustment':
        return TransactionType.adjustment;
      case 'stockTake':
        return TransactionType.stockTake;
      case 'return_':
        return TransactionType.return_;
      case 'other':
      default:
        return TransactionType.other;
    }
  }

  // Convert enum to string for JSON
  static String _transactionTypeToString(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return 'purchase';
      case TransactionType.sale:
        return 'sale';
      case TransactionType.transfer:
        return 'transfer';
      case TransactionType.adjustment:
        return 'adjustment';
      case TransactionType.stockTake:
        return 'stockTake';
      case TransactionType.return_:
        return 'return_';
      case TransactionType.other:
        return 'other';
    }
  }

  // Convert to JSON (for Appwrite document)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'sourceLocationId': sourceLocationId,
      'destinationLocationId': destinationLocationId,
      'quantity': quantity,
      'type': _transactionTypeToString(type),
      'referenceNumber': referenceNumber,
      'notes': notes,
      'transactionDate': transactionDate.toIso8601String(),
      'createdBy': createdBy,
      'additionalAttributes': additionalAttributes,
    };
  }

  // Create a copy with modified fields (override for proper typing)
  @override
  TransactionModel copyWith({
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
    return TransactionModel(
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
