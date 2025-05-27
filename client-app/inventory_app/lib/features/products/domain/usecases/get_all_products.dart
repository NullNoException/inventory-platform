import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/usecases/usecase.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';

class GetAllProducts implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
