import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/core/network/network_info.dart';
import 'package:inventory_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:inventory_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:inventory_app/features/authentication/data/models/user_model.dart';
import 'package:inventory_app/features/authentication/domain/entities/user.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // Check network connectivity
      if (await _networkInfo.isConnected) {
        // Attempt to sign in remotely
        final user = await _remoteDataSource.signIn(
          email: email,
          password: password,
        );

        // Cache user data locally
        await _localDataSource.cacheUser(user);

        // Save remember me preference
        await _localDataSource.setRememberMe(rememberMe);

        return Right(user);
      } else {
        // Offline login - check cached credentials
        // This is a simplified approach - in a real app, you'd need to securely store and verify credentials
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached credentials',
            ),
          );
        }
      }
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Sign up requires network connection
      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.signUp(
          name: name,
          email: email,
          password: password,
        );

        // Cache user data locally
        await _localDataSource.cacheUser(user);

        return Right(user);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Try to sign out remotely if online
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.signOut();
      }

      // Always clear local cache
      await _localDataSource.clearCachedUser();

      return const Right(null);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      // Check local cache first
      final isAuthenticated = await _localDataSource.isAuthenticated();

      // If we have a cached user and remember me is set, consider the user signed in
      if (isAuthenticated) {
        final rememberMe = await _localDataSource.getRememberMe();
        if (rememberMe) {
          return const Right(true);
        }
      }

      // If we're online, verify with server
      if (await _networkInfo.isConnected) {
        final user = await _remoteDataSource.getCurrentUser();
        if (user != null) {
          // Update cached user data
          await _localDataSource.cacheUser(user);
          return const Right(true);
        }
      }

      return const Right(false);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Try to get user from remote if online
      if (await _networkInfo.isConnected) {
        try {
          final user = await _remoteDataSource.getCurrentUser();
          if (user != null) {
            // Update cached user
            await _localDataSource.cacheUser(user);
            return Right(user);
          }
        } catch (_) {
          // Fall back to cached user if remote fails
        }
      }

      // Get cached user
      final cachedUser = await _localDataSource.getCachedUser();
      return Right(cachedUser);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      // Password reset requires network connection
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.resetPassword(email: email);
        return const Right(null);
      } else {
        return const Left(UnexpectedFailure(message: 'No internet connection'));
      }
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile({
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      // Update profile requires network connection
      if (await _networkInfo.isConnected) {
        final updatedUser = await _remoteDataSource.updateUserProfile(
          userId: userId,
          name: name,
          email: email,
        );

        // Update cached user
        await _localDataSource.cacheUser(updatedUser);

        return Right(updatedUser);
      } else {
        return const Left(UnexpectedFailure(message: 'No internet connection'));
      }
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Password change requires network connection
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } else {
        return const Left(UnexpectedFailure(message: 'No internet connection'));
      }
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
