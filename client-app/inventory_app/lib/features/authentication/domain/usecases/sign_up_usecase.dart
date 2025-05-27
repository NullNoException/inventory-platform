import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/entities/user.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
