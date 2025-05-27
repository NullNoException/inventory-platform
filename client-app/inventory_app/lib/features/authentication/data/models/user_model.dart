import 'package:inventory_app/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required List<String> roles,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    bool isActive = true,
  }) : super(
         id: id,
         name: name,
         email: email,
         roles: roles,
         createdAt: createdAt,
         lastLoginAt: lastLoginAt,
         isActive: isActive,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> parseRoles(dynamic roles) {
      if (roles is List) {
        return roles.cast<String>();
      } else if (roles is String) {
        return roles.split(',').map((e) => e.trim()).toList();
      }
      return [];
    }

    return UserModel(
      id: json["\$id"] ?? json['id'],
      name: json['name'],
      email: json['email'],
      roles: parseRoles(json['roles'] ?? json['labels'] ?? []),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      lastLoginAt:
          json['lastLoginAt'] != null
              ? DateTime.parse(json['lastLoginAt'])
              : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      roles: user.roles,
      createdAt: user.createdAt,
      lastLoginAt: user.lastLoginAt,
      isActive: user.isActive,
    );
  }
}
