import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class LocalStorageService {
  /// Save data to local storage
  Future<Either<Failure, void>> saveData<T>(
    String boxName,
    String key,
    T value,
  );

  /// Get data from local storage
  Future<Either<Failure, T?>> getData<T>(String boxName, String key);

  /// Remove data from local storage
  Future<Either<Failure, void>> removeData(String boxName, String key);

  /// Get all data from a box
  Future<Either<Failure, List<T>>> getAllData<T>(String boxName);

  /// Clear all data from a box
  Future<Either<Failure, void>> clearBox(String boxName);
}

class LocalStorageServiceImpl implements LocalStorageService {
  // Box names
  static const String userBox = 'userBox';
  static const String productBox = 'productBox';
  static const String inventoryBox = 'inventoryBox';
  static const String locationBox = 'locationBox';
  static const String transferBox = 'transferBox';
  static const String adjustmentBox = 'adjustmentBox';
  static const String countBox = 'countBox';
  static const String syncQueueBox = 'syncQueueBox';
  static const String settingsBox = 'settingsBox';

  // Initialize boxes
  Future<void> init() async {
    await Hive.openBox(userBox);
    await Hive.openBox(productBox);
    await Hive.openBox(inventoryBox);
    await Hive.openBox(locationBox);
    await Hive.openBox(transferBox);
    await Hive.openBox(adjustmentBox);
    await Hive.openBox(countBox);
    await Hive.openBox(syncQueueBox);
    await Hive.openBox(settingsBox);
  }

  @override
  Future<Either<Failure, void>> saveData<T>(
    String boxName,
    String key,
    T value,
  ) async {
    try {
      final box = await _getBox(boxName);
      await box.put(key, value);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to save data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, T?>> getData<T>(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      final value = box.get(key) as T?;
      return Right(value);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get data: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeData(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      await box.delete(key);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to remove data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<T>>> getAllData<T>(String boxName) async {
    try {
      final box = await _getBox(boxName);
      final values = box.values.cast<T>().toList();
      return Right(values);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to get all data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> clearBox(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to clear box: ${e.toString()}'),
      );
    }
  }

  // Helper method to get box
  Future<Box> _getBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }
}
