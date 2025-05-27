import 'package:equatable/equatable.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductsSearched extends ProductState {
  final List<Product> products;
  final String searchTerm;

  const ProductsSearched({required this.products, required this.searchTerm});

  @override
  List<Object> get props => [products, searchTerm];
}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductDeleted extends ProductState {
  final String id;

  const ProductDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
