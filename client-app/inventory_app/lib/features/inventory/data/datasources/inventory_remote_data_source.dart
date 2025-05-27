import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/services/appwrite_service.dart';
import 'package:inventory_app/features/inventory/data/models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getAllInventoryItems();
  Future<InventoryItemModel> getInventoryItemById(String id);
  Future<List<InventoryItemModel>> getInventoryItemsByProduct(String productId);
  Future<List<InventoryItemModel>> getInventoryItemsByLocation(
    String locationId,
  );
  Future<InventoryItemModel> createInventoryItem(InventoryItemModel item);
  Future<InventoryItemModel> updateInventoryItem(InventoryItemModel item);
  Future<bool> deleteInventoryItem(String id);
  Future<List<InventoryItemModel>> getLowStockItems();
  Future<List<InventoryItemModel>> getExpiringItems();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final AppwriteService _appwriteService;

  InventoryRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<List<InventoryItemModel>> getAllInventoryItems() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
      );

      return result.documents
          .map((doc) => InventoryItemModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<InventoryItemModel> getInventoryItemById(String id) async {
    try {
      final result = await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        documentId: id,
      );

      return InventoryItemModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<InventoryItemModel>> getInventoryItemsByProduct(
    String productId,
  ) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        queries: [Query.equal('productId', productId)],
      );

      return result.documents
          .map((doc) => InventoryItemModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<InventoryItemModel>> getInventoryItemsByLocation(
    String locationId,
  ) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        queries: [Query.equal('locationId', locationId)],
      );

      return result.documents
          .map((doc) => InventoryItemModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<InventoryItemModel> createInventoryItem(
    InventoryItemModel item,
  ) async {
    try {
      final result = await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        documentId: ID.unique(),
        data: item.toJson(),
      );

      return InventoryItemModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<InventoryItemModel> updateInventoryItem(
    InventoryItemModel item,
  ) async {
    try {
      final result = await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        documentId: item.id,
        data: item.toJson(),
      );

      return InventoryItemModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteInventoryItem(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        documentId: id,
      );

      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<InventoryItemModel>> getLowStockItems() async {
    try {
      // This is a simplified approach for low stock - in reality you might need a more complex query
      // depending on your business rules and how minQuantity is determined
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
      );

      // Filter items with low stock on the client side
      // In more advanced implementations, this filtering could be done in the database
      final items =
          result.documents
              .map((doc) => InventoryItemModel.fromJson(doc.data))
              .toList();

      return items.where((item) => item.isLowStock).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<InventoryItemModel>> getExpiringItems() async {
    try {
      // Get current date in ISO format
      final now = DateTime.now();
      final thirtyDaysLater = now.add(const Duration(days: 30));

      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.inventoryItemsCollectionId,
        // Get items where expiryDate is not null and is before 30 days from now
        queries: [
          Query.isNotNull('expiryDate'),
          Query.lessThan('expiryDate', thirtyDaysLater.toIso8601String()),
          Query.greaterThan('expiryDate', now.toIso8601String()),
        ],
      );

      return result.documents
          .map((doc) => InventoryItemModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
