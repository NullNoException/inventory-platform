import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/usecases/usecase.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';

class GetProductsByCategory
    implements UseCase<List<Product>, GetProductsByCategoryParams> {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
    GetProductsByCategoryParams params,
  ) {
    return repository.getProductsByCategory(params.categoryId);
  }
}

class GetProductsByCategoryParams extends Equatable {
  final String categoryId;

  const GetProductsByCategoryParams({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
