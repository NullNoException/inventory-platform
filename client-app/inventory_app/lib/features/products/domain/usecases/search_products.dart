import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/usecases/usecase.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';

class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) {
    return repository.searchProducts(params.searchTerm);
  }
}

class SearchProductsParams extends Equatable {
  final String searchTerm;

  const SearchProductsParams({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}
