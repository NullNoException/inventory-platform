import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  /// Get a list of all products
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get a product by its id
  Future<Either<Failure, Product>> getProductById(String id);

  /// Get products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  );

  /// Search products by term
  Future<Either<Failure, List<Product>>> searchProducts(String searchTerm);

  /// Create a new product
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Update an existing product
  Future<Either<Failure, Product>> updateProduct(Product product);

  /// Delete a product
  Future<Either<Failure, bool>> deleteProduct(String id);

  /// Get product by barcode
  Future<Either<Failure, Product>> getProductByBarcode(String barcode);

  /// Get products with low stock
  Future<Either<Failure, List<Product>>> getLowStockProducts();
}
