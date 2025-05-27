import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/entities/location.dart';

abstract class LocationRepository {
  /// Get a list of all locations
  Future<Either<Failure, List<Location>>> getAllLocations();

  /// Get a location by its id
  Future<Either<Failure, Location>> getLocationById(String id);

  /// Get locations by type
  Future<Either<Failure, List<Location>>> getLocationsByType(String type);

  /// Create a new location
  Future<Either<Failure, Location>> createLocation(Location location);

  /// Update an existing location
  Future<Either<Failure, Location>> updateLocation(Location location);

  /// Delete a location
  Future<Either<Failure, bool>> deleteLocation(String id);

  /// Search locations by term
  Future<Either<Failure, List<Location>>> searchLocations(String searchTerm);
}
