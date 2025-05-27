import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String sku; // Stock Keeping Unit
  final String barcode;
  final String categoryId;
  final double price;
  final double cost;
  final String unit; // e.g., pieces, kg, liters
  final String imageUrl;
  final bool isActive;
  final Map<String, dynamic> attributes; // For custom product attributes
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.barcode,
    required this.categoryId,
    required this.price,
    required this.cost,
    this.unit = 'piece',
    this.imageUrl = '',
    this.isActive = true,
    this.attributes = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  double get margin => price - cost;
  double get marginPercentage => cost > 0 ? ((price - cost) / cost) * 100 : 0;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    sku,
    barcode,
    categoryId,
    price,
    cost,
    unit,
    imageUrl,
    isActive,
    attributes,
    createdAt,
    updatedAt,
  ];

  // Create a copy with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? sku,
    String? barcode,
    String? categoryId,
    double? price,
    double? cost,
    String? unit,
    String? imageUrl,
    bool? isActive,
    Map<String, dynamic>? attributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      attributes: attributes ?? this.attributes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
