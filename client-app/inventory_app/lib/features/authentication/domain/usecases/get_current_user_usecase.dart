import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/entities/user.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
