import 'package:inventory_app/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String description,
    required String sku,
    required String barcode,
    required String categoryId,
    required double price,
    required double cost,
    String unit = 'piece',
    String imageUrl = '',
    bool isActive = true,
    Map<String, dynamic> attributes = const {},
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         name: name,
         description: description,
         sku: sku,
         barcode: barcode,
         categoryId: categoryId,
         price: price,
         cost: cost,
         unit: unit,
         imageUrl: imageUrl,
         isActive: isActive,
         attributes: attributes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  // Convert from JSON (from Appwrite document)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['\$id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      categoryId: json['categoryId'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      cost: (json['cost'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? 'piece',
      imageUrl: json['imageUrl'] ?? '',
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
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'categoryId': categoryId,
      'price': price,
      'cost': cost,
      'unit': unit,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'attributes': attributes,
    };
  }

  // Create a copy with modified fields (override for proper typing)
  @override
  ProductModel copyWith({
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
    return ProductModel(
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
