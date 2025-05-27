import 'package:inventory_app/features/inventory/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    required String description,
    String? parentId,
    bool isActive = true,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String createdBy,
  }) : super(
         id: id,
         name: name,
         description: description,
         parentId: parentId,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
         createdBy: createdBy,
       );

  // Convert from JSON (from Appwrite document)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['\$id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      parentId: json['parentId'],
      isActive: json['isActive'] ?? true,
      createdAt:
          json['\$createdAt'] != null
              ? DateTime.parse(json['\$createdAt'])
              : DateTime.now(),
      updatedAt:
          json['\$updatedAt'] != null
              ? DateTime.parse(json['\$updatedAt'])
              : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
    );
  }

  // Convert to JSON (for Appwrite document)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'parentId': parentId,
      'isActive': isActive,
      'createdBy': createdBy,
    };
  }

  // Create a copy with modified fields (override for proper typing)
  @override
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
