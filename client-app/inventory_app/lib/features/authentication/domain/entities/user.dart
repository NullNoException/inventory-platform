import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    roles,
    createdAt,
    lastLoginAt,
    isActive,
  ];

  bool get isAdmin => roles.contains('admin');
  bool get isManager => roles.contains('manager');
  bool get isStaff => roles.contains('staff');
}
