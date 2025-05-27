import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/errors/exceptions.dart';
import 'package:inventory_app/core/services/appwrite_service.dart';
import 'package:inventory_app/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
  Future<List<ProductModel>> searchProducts(String searchTerm);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<ProductModel> getProductByBarcode(String barcode);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final AppwriteService _appwriteService;

  ProductRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
      );

      return result.documents
          .map((doc) => ProductModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final result = await _appwriteService.databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        documentId: id,
      );

      return ProductModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        queries: [Query.equal('categoryId', categoryId)],
      );

      return result.documents
          .map((doc) => ProductModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String searchTerm) async {
    try {
      // Combined search in name, description and SKU
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        queries: [
          Query.search('name', searchTerm),
          Query.search('description', searchTerm),
          Query.search('sku', searchTerm),
        ],
      );

      return result.documents
          .map((doc) => ProductModel.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final result = await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        documentId: ID.unique(),
        data: product.toJson(),
      );

      return ProductModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final result = await _appwriteService.databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        documentId: product.id,
        data: product.toJson(),
      );

      return ProductModel.fromJson(result.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      await _appwriteService.databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        documentId: id,
      );

      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductByBarcode(String barcode) async {
    try {
      final result = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productsCollectionId,
        queries: [Query.equal('barcode', barcode)],
      );

      if (result.documents.isEmpty) {
        throw NotFoundException(
          message: 'Product with barcode $barcode not found',
        );
      }

      return ProductModel.fromJson(result.documents.first.data);
    } catch (e) {
      if (e is NotFoundException) {
        throw e;
      }
      throw ServerException(message: e.toString());
    }
  }
}
