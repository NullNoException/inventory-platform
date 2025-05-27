import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/entities/user.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    return await repository.signIn(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
