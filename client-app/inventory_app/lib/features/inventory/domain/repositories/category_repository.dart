import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/entities/category.dart';

abstract class CategoryRepository {
  /// Get all categories
  Future<Either<Failure, List<Category>>> getAllCategories();

  /// Get a category by id
  Future<Either<Failure, Category>> getCategoryById(String id);

  /// Get child categories of a parent category
  Future<Either<Failure, List<Category>>> getChildCategories(String parentId);

  /// Get root categories (categories without a parent)
  Future<Either<Failure, List<Category>>> getRootCategories();

  /// Create a new category
  Future<Either<Failure, Category>> createCategory(Category category);

  /// Update an existing category
  Future<Either<Failure, Category>> updateCategory(Category category);

  /// Delete a category
  Future<Either<Failure, bool>> deleteCategory(String id);

  /// Search categories by term
  Future<Either<Failure, List<Category>>> searchCategories(String searchTerm);
}
