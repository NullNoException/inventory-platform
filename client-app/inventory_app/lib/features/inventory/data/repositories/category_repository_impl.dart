import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/data/datasources/category_remote_data_source.dart';
import 'package:inventory_app/features/inventory/data/models/category_model.dart';
import 'package:inventory_app/features/inventory/domain/entities/category.dart';
import 'package:inventory_app/features/inventory/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categories = await remoteDataSource.getAllCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id) async {
    try {
      final category = await remoteDataSource.getCategoryById(id);
      return Right(category);
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
  Future<Either<Failure, List<Category>>> getChildCategories(
    String parentId,
  ) async {
    try {
      final categories = await remoteDataSource.getChildCategories(parentId);
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getRootCategories() async {
    try {
      final categories = await remoteDataSource.getRootCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory(Category category) async {
    try {
      // Convert from domain entity to data model
      final categoryModel =
          category is CategoryModel
              ? category
              : CategoryModel(
                id: category.id,
                name: category.name,
                description: category.description,
                parentId: category.parentId,
                isActive: category.isActive,
                createdAt: category.createdAt,
                updatedAt: category.updatedAt,
                createdBy: category.createdBy,
              );

      final newCategory = await remoteDataSource.createCategory(categoryModel);
      return Right(newCategory);
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
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      // Convert from domain entity to data model
      final categoryModel =
          category is CategoryModel
              ? category as CategoryModel
              : CategoryModel(
                id: category.id,
                name: category.name,
                description: category.description,
                parentId: category.parentId,
                isActive: category.isActive,
                createdAt: category.createdAt,
                updatedAt: category.updatedAt,
                createdBy: category.createdBy,
              );

      final updatedCategory = await remoteDataSource.updateCategory(
        categoryModel,
      );
      return Right(updatedCategory);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String id) async {
    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(true);
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
  Future<Either<Failure, List<Category>>> searchCategories(
    String searchTerm,
  ) async {
    try {
      final categories = await remoteDataSource.searchCategories(searchTerm);
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
