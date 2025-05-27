import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/entities/transaction.dart';

abstract class TransactionRepository {
  /// Get all transactions
  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  /// Get a transaction by id
  Future<Either<Failure, Transaction>> getTransactionById(String id);

  /// Get transactions by product
  Future<Either<Failure, List<Transaction>>> getTransactionsByProduct(
    String productId,
  );

  /// Get transactions by location (either source or destination)
  Future<Either<Failure, List<Transaction>>> getTransactionsByLocation(
    String locationId,
  );

  /// Get transactions by type
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    TransactionType type,
  );

  /// Get transactions by date range
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Create a new transaction
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  );

  /// Update an existing transaction
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  );

  /// Delete a transaction
  Future<Either<Failure, bool>> deleteTransaction(String id);

  /// Record a product transfer between locations
  Future<Either<Failure, Transaction>> recordTransfer(
    String productId,
    String sourceLocationId,
    String destinationLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  );

  /// Record a product purchase (incoming inventory)
  Future<Either<Failure, Transaction>> recordPurchase(
    String productId,
    String destinationLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  );

  /// Record a product sale (outgoing inventory)
  Future<Either<Failure, Transaction>> recordSale(
    String productId,
    String sourceLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  );
}
