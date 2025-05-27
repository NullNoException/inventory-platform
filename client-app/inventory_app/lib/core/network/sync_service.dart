import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/network/network_info.dart';
import 'package:inventory_app/core/storage/local_storage_service.dart';
import 'package:rxdart/rxdart.dart';

enum SyncStatus { idle, syncing, error, completed }

class SyncItem {
  final String id;
  final String entity;
  final String operation; // create, update, delete
  final Map<String, dynamic> data;
  final DateTime timestamp;

  SyncItem({
    required this.id,
    required this.entity,
    required this.operation,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity': entity,
    'operation': operation,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SyncItem.fromJson(Map<String, dynamic> json) {
    return SyncItem(
      id: json['id'],
      entity: json['entity'],
      operation: json['operation'],
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

abstract class SyncService {
  Future<Either<Failure, void>> queueForSync(SyncItem item);
  Future<Either<Failure, void>> syncAll();
  Stream<SyncStatus> get syncStatusStream;
  Future<Either<Failure, List<SyncItem>>> getPendingSyncItems();
}

class SyncServiceImpl implements SyncService {
  final LocalStorageService _storageService;
  final NetworkInfo _networkInfo;
  final _syncStatusController = BehaviorSubject<SyncStatus>.seeded(
    SyncStatus.idle,
  );
  static const String syncQueueBox = LocalStorageServiceImpl.syncQueueBox;

  SyncServiceImpl({
    required LocalStorageService storageService,
    required NetworkInfo networkInfo,
  }) : _storageService = storageService,
       _networkInfo = networkInfo {
    // Listen to network changes to trigger sync when connection is restored
    _networkInfo.connectionStream.listen((isConnected) {
      if (isConnected) {
        syncAll();
      }
    });
  }

  @override
  Future<Either<Failure, void>> queueForSync(SyncItem item) async {
    try {
      // Store the sync item in the queue box
      final result = await _storageService.saveData(
        syncQueueBox,
        '${item.entity}_${item.id}_${item.timestamp.millisecondsSinceEpoch}',
        item.toJson(),
      );

      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to queue item for sync: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> syncAll() async {
    // Check if we're online
    if (!await _networkInfo.isConnected) {
      return const Left(
        NetworkFailure(message: 'Cannot sync: Device is offline'),
      );
    }

    // Update status to syncing
    _syncStatusController.add(SyncStatus.syncing);

    try {
      // Get all pending sync items
      final itemsResult = await getPendingSyncItems();

      return await itemsResult.fold(
        (failure) {
          _syncStatusController.add(SyncStatus.error);
          return Left(failure);
        },
        (items) async {
          if (items.isEmpty) {
            _syncStatusController.add(SyncStatus.completed);
            return const Right(null);
          }

          // Sort items by timestamp
          items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

          // Process each item by entity and operation
          for (var item in items) {
            try {
              // This is a placeholder for actual remote sync implementation
              // In a real implementation, we would call entity-specific repository methods
              // to handle the sync operation based on entity type and operation

              // For example:
              // if (item.entity == 'product') {
              //   if (item.operation == 'create') {
              //     await _productRepository.createRemote(item.data);
              //   } else if (item.operation == 'update') {
              //     await _productRepository.updateRemote(item.id, item.data);
              //   } else if (item.operation == 'delete') {
              //     await _productRepository.deleteRemote(item.id);
              //   }
              // }

              // After successful sync, remove from queue
              await _storageService.removeData(
                syncQueueBox,
                '${item.entity}_${item.id}_${item.timestamp.millisecondsSinceEpoch}',
              );
            } catch (e) {
              // If an item fails to sync, continue with the next one
              continue;
            }
          }

          _syncStatusController.add(SyncStatus.completed);
          return const Right(null);
        },
      );
    } catch (e) {
      _syncStatusController.add(SyncStatus.error);
      return Left(UnexpectedFailure(message: 'Sync failed: ${e.toString()}'));
    }
  }

  @override
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  @override
  Future<Either<Failure, List<SyncItem>>> getPendingSyncItems() async {
    try {
      final result = await _storageService.getAllData<Map<String, dynamic>>(
        syncQueueBox,
      );

      return result.fold((failure) => Left(failure), (itemsJson) {
        final items = itemsJson.map((json) => SyncItem.fromJson(json)).toList();
        return Right(items);
      });
    } catch (e) {
      return Left(
        CacheFailure(
          message: 'Failed to get pending sync items: ${e.toString()}',
        ),
      );
    }
  }

  void dispose() {
    _syncStatusController.close();
  }
}
