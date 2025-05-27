import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/data/datasources/transaction_remote_data_source.dart';
import 'package:inventory_app/features/inventory/data/models/transaction_model.dart';
import 'package:inventory_app/features/inventory/domain/entities/transaction.dart';
import 'package:inventory_app/features/inventory/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final transactions = await remoteDataSource.getAllTransactions();
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final transaction = await remoteDataSource.getTransactionById(id);
      return Right(transaction);
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
  Future<Either<Failure, List<Transaction>>> getTransactionsByProduct(
    String productId,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactionsByProduct(
        productId,
      );
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByLocation(
    String locationId,
  ) async {
    try {
      // Get transactions where the location is either source or destination
      final sourceTransactions = await remoteDataSource
          .getTransactionsByLocation(locationId, isSource: true);
      final destTransactions = await remoteDataSource.getTransactionsByLocation(
        locationId,
        isSource: false,
      );

      // Combine and return both lists
      final allTransactions = [...sourceTransactions, ...destTransactions];
      return Right(allTransactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
    TransactionType type,
  ) async {
    try {
      // Get all transactions and filter by type on the client side
      // This could be optimized later with a server-side query
      final allTransactions = await remoteDataSource.getAllTransactions();
      final filteredTransactions =
          allTransactions.where((t) => t.type == type).toList();

      return Right(filteredTransactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await remoteDataSource.getTransactionsByDateRange(
        startDate,
        endDate,
      );
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      // Convert domain entity to data model
      final transactionModel =
          transaction is TransactionModel
              ? transaction as TransactionModel
              : TransactionModel(
                id: transaction.id,
                productId: transaction.productId,
                sourceLocationId: transaction.sourceLocationId,
                destinationLocationId: transaction.destinationLocationId,
                quantity: transaction.quantity,
                type: transaction.type,
                referenceNumber: transaction.referenceNumber,
                notes: transaction.notes,
                transactionDate: transaction.transactionDate,
                createdAt: transaction.createdAt,
                updatedAt: transaction.updatedAt,
                createdBy: transaction.createdBy,
                additionalAttributes: transaction.additionalAttributes,
              );

      final newTransaction = await remoteDataSource.createTransaction(
        transactionModel,
      );
      return Right(newTransaction);
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
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      // Convert domain entity to data model
      final transactionModel =
          transaction is TransactionModel
              ? transaction as TransactionModel
              : TransactionModel(
                id: transaction.id,
                productId: transaction.productId,
                sourceLocationId: transaction.sourceLocationId,
                destinationLocationId: transaction.destinationLocationId,
                quantity: transaction.quantity,
                type: transaction.type,
                referenceNumber: transaction.referenceNumber,
                notes: transaction.notes,
                transactionDate: transaction.transactionDate,
                createdAt: transaction.createdAt,
                updatedAt: transaction.updatedAt,
                createdBy: transaction.createdBy,
                additionalAttributes: transaction.additionalAttributes,
              );

      final updatedTransaction = await remoteDataSource.updateTransaction(
        transactionModel,
      );
      return Right(updatedTransaction);
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
  Future<Either<Failure, bool>> deleteTransaction(String id) async {
    try {
      final isDeleted = await remoteDataSource.deleteTransaction(id);
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
  Future<Either<Failure, Transaction>> recordTransfer(
    String productId,
    String sourceLocationId,
    String destinationLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  ) async {
    try {
      final now = DateTime.now();

      // Create a new transaction
      final transaction = TransactionModel(
        id: '', // Will be generated by Appwrite
        productId: productId,
        sourceLocationId: sourceLocationId,
        destinationLocationId: destinationLocationId,
        quantity: quantity,
        type: TransactionType.transfer,
        referenceNumber: referenceNumber,
        notes: notes,
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
        createdBy: 'current_user_id', // TODO: Get from auth context
        additionalAttributes: {},
      );

      return await createTransaction(transaction);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> recordPurchase(
    String productId,
    String destinationLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  ) async {
    try {
      final now = DateTime.now();

      // Create a new transaction
      final transaction = TransactionModel(
        id: '', // Will be generated by Appwrite
        productId: productId,
        sourceLocationId: '', // No source for purchases
        destinationLocationId: destinationLocationId,
        quantity: quantity,
        type: TransactionType.purchase,
        referenceNumber: referenceNumber,
        notes: notes,
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
        createdBy: 'current_user_id', // TODO: Get from auth context
        additionalAttributes: {},
      );

      return await createTransaction(transaction);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> recordSale(
    String productId,
    String sourceLocationId,
    int quantity,
    String referenceNumber,
    String notes,
  ) async {
    try {
      final now = DateTime.now();

      // Create a new transaction
      final transaction = TransactionModel(
        id: '', // Will be generated by Appwrite
        productId: productId,
        sourceLocationId: sourceLocationId,
        destinationLocationId: '', // No destination for sales
        quantity: quantity,
        type: TransactionType.sale,
        referenceNumber: referenceNumber,
        notes: notes,
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
        createdBy: 'current_user_id', // TODO: Get from auth context
        additionalAttributes: {},
      );

      return await createTransaction(transaction);
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
