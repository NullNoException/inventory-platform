import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) async {
    return await repository.resetPassword(email: email);
  }
}
