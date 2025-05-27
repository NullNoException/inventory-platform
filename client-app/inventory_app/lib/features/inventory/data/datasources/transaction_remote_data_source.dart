import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/services/appwrite_service.dart';
import 'package:inventory_app/features/inventory/data/models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById(String id);
  Future<List<TransactionModel>> getTransactionsByProduct(String productId);
  Future<List<TransactionModel>> getTransactionsByLocation(
    String locationId, {
    bool isSource = true,
  });
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<bool> deleteTransaction(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final AppwriteService _appwriteService;

  TransactionRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
      );

      return result.documents
          .map((doc) => TransactionModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final result = await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        documentId: id,
      );

      return TransactionModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByProduct(
    String productId,
  ) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        queries: [Query.equal('productId', productId)],
      );

      return result.documents
          .map((doc) => TransactionModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByLocation(
    String locationId, {
    bool isSource = true,
  }) async {
    try {
      final field = isSource ? 'sourceLocationId' : 'destinationLocationId';

      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        queries: [Query.equal(field, locationId)],
      );

      return result.documents
          .map((doc) => TransactionModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        queries: [
          Query.greaterThanEqual('transactionDate', start.toIso8601String()),
          Query.lessThanEqual('transactionDate', end.toIso8601String()),
        ],
      );

      return result.documents
          .map((doc) => TransactionModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final result = await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        documentId: ID.unique(),
        data: transaction.toJson(),
      );

      return TransactionModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final result = await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        documentId: transaction.id,
        data: transaction.toJson(),
      );

      return TransactionModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteTransaction(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.transactionsCollectionId,
        documentId: id,
      );

      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
