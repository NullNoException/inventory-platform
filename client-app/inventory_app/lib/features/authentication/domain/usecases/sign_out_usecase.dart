import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
