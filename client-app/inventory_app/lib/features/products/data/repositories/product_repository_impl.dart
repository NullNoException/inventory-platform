import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:inventory_app/features/products/data/models/product_model.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  ) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(
    String searchTerm,
  ) async {
    try {
      final products = await remoteDataSource.searchProducts(searchTerm);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    try {
      // Convert from domain entity to data model
      final productModel =
          product is ProductModel
              ? product
              : ProductModel(
                id: product.id,
                name: product.name,
                description: product.description,
                sku: product.sku,
                barcode: product.barcode,
                categoryId: product.categoryId,
                price: product.price,
                cost: product.cost,
                unit: product.unit,
                imageUrl: product.imageUrl,
                isActive: product.isActive,
                attributes: product.attributes,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              );

      final newProduct = await remoteDataSource.createProduct(productModel);
      return Right(newProduct);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      // Convert from domain entity to data model
      final productModel =
          product is ProductModel
              ? product as ProductModel
              : ProductModel(
                id: product.id,
                name: product.name,
                description: product.description,
                sku: product.sku,
                barcode: product.barcode,
                categoryId: product.categoryId,
                price: product.price,
                cost: product.cost,
                unit: product.unit,
                imageUrl: product.imageUrl,
                isActive: product.isActive,
                attributes: product.attributes,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              );

      final updatedProduct = await remoteDataSource.updateProduct(productModel);
      return Right(updatedProduct);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    try {
      final isDeleted = await remoteDataSource.deleteProduct(id);
      return Right(isDeleted);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductByBarcode(String barcode) async {
    try {
      final product = await remoteDataSource.getProductByBarcode(barcode);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    try {
      // This would typically query inventoryItems and join with products
      // For simplicity, we'll implement this in a future iteration
      return Right([]);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
