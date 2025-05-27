import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/services/appwrite_service.dart';
import 'package:inventory_app/features/inventory/data/models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationModel>> getAllLocations();
  Future<LocationModel> getLocationById(String id);
  Future<List<LocationModel>> getLocationsByType(String type);
  Future<LocationModel> createLocation(LocationModel location);
  Future<LocationModel> updateLocation(LocationModel location);
  Future<bool> deleteLocation(String id);
  Future<List<LocationModel>> searchLocations(String searchTerm);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final AppwriteService _appwriteService;

  LocationRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<List<LocationModel>> getAllLocations() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
      );

      return result.documents
          .map((doc) => LocationModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LocationModel> getLocationById(String id) async {
    try {
      final result = await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        documentId: id,
      );

      return LocationModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationModel>> getLocationsByType(String type) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        queries: [Query.equal('type', type)],
      );

      return result.documents
          .map((doc) => LocationModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LocationModel> createLocation(LocationModel location) async {
    try {
      final result = await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        documentId: ID.unique(),
        data: location.toJson(),
      );

      return LocationModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<LocationModel> updateLocation(LocationModel location) async {
    try {
      final result = await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        documentId: location.id,
        data: location.toJson(),
      );

      return LocationModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteLocation(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        documentId: id,
      );

      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LocationModel>> searchLocations(String searchTerm) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.locationsCollectionId,
        queries: [
          Query.search('name', searchTerm),
          Query.search('code', searchTerm),
          Query.search('address', searchTerm),
        ],
      );

      return result.documents
          .map((doc) => LocationModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}