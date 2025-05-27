import 'dart:convert';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/storage/local_storage_service.dart';
import 'package:inventory_app/features/authentication/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Clear cached user data
  Future<void> clearCachedUser();

  /// Check if user is authenticated locally
  Future<bool> isAuthenticated();

  /// Set remember me preference
  Future<void> setRememberMe(bool value);

  /// Get remember me preference
  Future<bool> getRememberMe();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageService _storageService;
  static const userKey = 'cached_user';
  static const rememberMeKey = 'remember_me';
  static const userBox = LocalStorageServiceImpl.userBox;
  static const settingsBox = LocalStorageServiceImpl.settingsBox;

  AuthLocalDataSourceImpl({required LocalStorageService storageService})
    : _storageService = storageService;

  @override
  Future<UserModel?> getCachedUser() async {
    final result = await _storageService.getData<String>(userBox, userKey);

    return result.fold(
      (failure) => throw CacheFailure(message: 'Failed to get cached user'),
      (jsonString) {
        if (jsonString == null) return null;

        try {
          final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
          return UserModel.fromJson(jsonMap);
        } catch (e) {
          throw CacheFailure(message: 'Invalid cached user data format');
        }
      },
    );
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    final result = await _storageService.saveData<String>(
      userBox,
      userKey,
      userJson,
    );

    result.fold(
      (failure) => throw CacheFailure(message: 'Failed to cache user data'),
      (_) => null,
    );
  }

  @override
  Future<void> clearCachedUser() async {
    final result = await _storageService.removeData(userBox, userKey);

    result.fold(
      (failure) => throw CacheFailure(message: 'Failed to clear cached user'),
      (_) => null,
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCachedUser();
    return user != null;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    final result = await _storageService.saveData<bool>(
      settingsBox,
      rememberMeKey,
      value,
    );

    result.fold(
      (failure) =>
          throw CacheFailure(message: 'Failed to save remember me preference'),
      (_) => null,
    );
  }

  @override
  Future<bool> getRememberMe() async {
    final result = await _storageService.getData<bool>(
      settingsBox,
      rememberMeKey,
    );

    return result.fold(
      (failure) =>
          throw CacheFailure(message: 'Failed to get remember me preference'),
      (value) => value ?? false,
    );
  }
}
