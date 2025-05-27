import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/data/datasources/inventory_remote_data_source.dart';
import 'package:inventory_app/features/inventory/data/models/inventory_item_model.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:inventory_app/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InventoryItem>>> getAllInventoryItems() async {
    try {
      final items = await remoteDataSource.getAllInventoryItems();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> getInventoryItemByProductAndLocation(
    String productId,
    String locationId,
  ) async {
    try {
      final items = await remoteDataSource.getInventoryItemsByProduct(
        productId,
      );
      final itemAtLocation = items.firstWhere(
        (item) => item.locationId == locationId,
        orElse:
            () =>
                throw NotFoundException(
                  message:
                      'No inventory item found for this product at this location',
                ),
      );
      return Right(itemAtLocation);
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
  Future<Either<Failure, List<InventoryItem>>> getInventoryItemsByProduct(
    String productId,
  ) async {
    try {
      final items = await remoteDataSource.getInventoryItemsByProduct(
        productId,
      );
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> getInventoryItemsByLocation(
    String locationId,
  ) async {
    try {
      final items = await remoteDataSource.getInventoryItemsByLocation(
        locationId,
      );
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> createInventoryItem(
    InventoryItem item,
  ) async {
    try {
      // Convert from domain entity to data model
      final itemModel =
          item is InventoryItemModel
              ? item as InventoryItemModel
              : InventoryItemModel(
                id: item.id,
                productId: item.productId,
                locationId: item.locationId,
                quantity: item.quantity,
                minQuantity: item.minQuantity,
                maxQuantity: item.maxQuantity,
                batchNumber: item.batchNumber,
                expiryDate: item.expiryDate,
                additionalAttributes: item.additionalAttributes,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
                lastUpdatedBy: item.lastUpdatedBy,
              );

      final newItem = await remoteDataSource.createInventoryItem(itemModel);
      return Right(newItem);
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
  Future<Either<Failure, InventoryItem>> updateInventoryItem(
    InventoryItem item,
  ) async {
    try {
      // Convert from domain entity to data model
      final itemModel =
          item is InventoryItemModel
              ? item as InventoryItemModel
              : InventoryItemModel(
                id: item.id,
                productId: item.productId,
                locationId: item.locationId,
                quantity: item.quantity,
                minQuantity: item.minQuantity,
                maxQuantity: item.maxQuantity,
                batchNumber: item.batchNumber,
                expiryDate: item.expiryDate,
                additionalAttributes: item.additionalAttributes,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt,
                lastUpdatedBy: item.lastUpdatedBy,
              );

      final updatedItem = await remoteDataSource.updateInventoryItem(itemModel);
      return Right(updatedItem);
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
  Future<Either<Failure, bool>> deleteInventoryItem(String id) async {
    try {
      final isDeleted = await remoteDataSource.deleteInventoryItem(id);
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
  Future<Either<Failure, InventoryItem>> adjustInventory(
    String productId,
    String locationId,
    int quantityChange,
    String reason,
  ) async {
    try {
      // Get the current inventory item
      final result = await getInventoryItemByProductAndLocation(
        productId,
        locationId,
      );

      return result.fold((failure) => Left(failure), (item) async {
        // Update the quantity
        final updatedItem = item.copyWith(
          quantity: item.quantity + quantityChange,
          updatedAt: DateTime.now(),
        );

        // Save the updated item
        return await updateInventoryItem(updatedItem);
      });
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> getLowStockItems() async {
    try {
      final items = await remoteDataSource.getLowStockItems();
      return Right(items);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> recordStockTake(
    String productId,
    String locationId,
    int newQuantity,
    String notes,
  ) async {
    try {
      // Get the current inventory item
      final result = await getInventoryItemByProductAndLocation(
        productId,
        locationId,
      );

      return result.fold((failure) => Left(failure), (item) async {
        // Update the quantity based on stock take
        final updatedItem = item.copyWith(
          quantity: newQuantity,
          updatedAt: DateTime.now(),
          additionalAttributes: {
            ...item.additionalAttributes,
            'lastStockTakeDate': DateTime.now().toIso8601String(),
            'lastStockTakeNotes': notes,
          },
        );

        // Save the updated item
        return await updateInventoryItem(updatedItem);
      });
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
