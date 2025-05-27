import 'package:equatable/equatable.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final String id;

  const LoadProductById({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchProducts extends ProductEvent {
  final String searchTerm;

  const SearchProducts({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  const CreateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  const UpdateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadProductsByCategory extends ProductEvent {
  final String categoryId;

  const LoadProductsByCategory({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
