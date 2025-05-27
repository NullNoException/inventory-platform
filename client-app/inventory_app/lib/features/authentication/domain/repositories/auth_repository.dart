import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {
  /// Sign in a user with email and password
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Sign up a new user
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Check if a user is currently signed in
  Future<Either<Failure, bool>> isSignedIn();

  /// Get the current signed-in user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Request a password reset for an email
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Update user profile information
  Future<Either<Failure, User>> updateUserProfile({
    required String userId,
    String? name,
    String? email,
  });

  /// Change user password
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
