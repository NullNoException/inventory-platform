import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/services/appwrite_service.dart';
import 'package:inventory_app/features/inventory/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<List<CategoryModel>> getChildCategories(String parentId);
  Future<List<CategoryModel>> getRootCategories();
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(String id);
  Future<List<CategoryModel>> searchCategories(String searchTerm);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final AppwriteService _appwriteService;

  CategoryRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
      );

      return result.documents
          .map((doc) => CategoryModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final result = await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        documentId: id,
      );

      return CategoryModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getChildCategories(String parentId) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        queries: [Query.equal('parentId', parentId)],
      );

      return result.documents
          .map((doc) => CategoryModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getRootCategories() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        queries: [Query.isNull('parentId')],
      );

      return result.documents
          .map((doc) => CategoryModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final result = await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        documentId: ID.unique(),
        data: category.toJson(),
      );

      return CategoryModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    try {
      final result = await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        documentId: category.id,
        data: category.toJson(),
      );

      return CategoryModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteCategory(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        documentId: id,
      );

      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> searchCategories(String searchTerm) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.categoriesCollectionId,
        queries: [
          Query.search('name', searchTerm),
          Query.search('description', searchTerm),
        ],
      );

      return result.documents
          .map((doc) => CategoryModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}