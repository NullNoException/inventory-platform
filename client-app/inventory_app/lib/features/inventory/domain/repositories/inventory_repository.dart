import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  /// Get all inventory items
  Future<Either<Failure, List<InventoryItem>>> getAllInventoryItems();

  /// Get an inventory item by product and location
  Future<Either<Failure, InventoryItem>> getInventoryItemByProductAndLocation(
    String productId,
    String locationId,
  );

  /// Get all inventory items for a product across all locations
  Future<Either<Failure, List<InventoryItem>>> getInventoryItemsByProduct(
    String productId,
  );

  /// Get all inventory items at a specific location
  Future<Either<Failure, List<InventoryItem>>> getInventoryItemsByLocation(
    String locationId,
  );

  /// Create a new inventory item
  Future<Either<Failure, InventoryItem>> createInventoryItem(
    InventoryItem item,
  );

  /// Update an existing inventory item
  Future<Either<Failure, InventoryItem>> updateInventoryItem(
    InventoryItem item,
  );

  /// Delete an inventory item
  Future<Either<Failure, bool>> deleteInventoryItem(String id);

  /// Adjust inventory quantity
  Future<Either<Failure, InventoryItem>> adjustInventory(
    String productId,
    String locationId,
    int quantityChange,
    String reason,
  );

  /// Get low stock inventory items
  Future<Either<Failure, List<InventoryItem>>> getLowStockItems();

  /// Record a stock take for an inventory item
  Future<Either<Failure, InventoryItem>> recordStockTake(
    String productId,
    String locationId,
    int newQuantity,
    String notes,
  );
}
