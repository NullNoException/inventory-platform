import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? parentId; // For hierarchical categories
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.parentId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    parentId,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
  ];

  // Create a copy with modified fields
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return Category(
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
