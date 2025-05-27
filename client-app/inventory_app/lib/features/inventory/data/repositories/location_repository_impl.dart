import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/data/datasources/location_remote_data_source.dart';
import 'package:inventory_app/features/inventory/data/models/location_model.dart';
import 'package:inventory_app/features/inventory/domain/entities/location.dart';
import 'package:inventory_app/features/inventory/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Location>>> getAllLocations() async {
    try {
      final locations = await remoteDataSource.getAllLocations();
      return Right(locations);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Location>> getLocationById(String id) async {
    try {
      final location = await remoteDataSource.getLocationById(id);
      return Right(location);
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
  Future<Either<Failure, List<Location>>> getLocationsByType(
    String type,
  ) async {
    try {
      final locations = await remoteDataSource.getLocationsByType(type);
      return Right(locations);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Location>> createLocation(Location location) async {
    try {
      // Convert from domain entity to data model
      final locationModel =
          location is LocationModel
              ? location
              : LocationModel(
                  id: location.id,
                  name: location.name,
                  code: location.code,
                  type: location.type,
                  address: location.address,
                  contactPerson: location.contactPerson,
                  contactPhone: location.contactPhone,
                  contactEmail: location.contactEmail,
                  isActive: location.isActive,
                  attributes: location.attributes,
                  createdAt: location.createdAt,
                  updatedAt: location.updatedAt,
                );

      final newLocation = await remoteDataSource.createLocation(locationModel);
      return Right(newLocation);
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
  Future<Either<Failure, Location>> updateLocation(Location location) async {
    try {
      // Convert from domain entity to data model
      final locationModel =
          location is LocationModel
              ? location as LocationModel
              : LocationModel(
                  id: location.id,
                  name: location.name,
                  code: location.code,
                  type: location.type,
                  address: location.address,
                  contactPerson: location.contactPerson,
                  contactPhone: location.contactPhone,
                  contactEmail: location.contactEmail,
                  isActive: location.isActive,
                  attributes: location.attributes,
                  createdAt: location.createdAt,
                  updatedAt: location.updatedAt,
                );

      final updatedLocation =
          await remoteDataSource.updateLocation(locationModel);
      return Right(updatedLocation);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLocation(String id) async {
    try {
      await remoteDataSource.deleteLocation(id);
      return const Right(true);
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
  Future<Either<Failure, List<Location>>> searchLocations(
    String searchTerm,
  ) async {
    try {
      final locations = await remoteDataSource.searchLocations(searchTerm);
      return Right(locations);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}