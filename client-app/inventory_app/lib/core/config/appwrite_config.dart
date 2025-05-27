import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';

class AppwriteConfig {
  // Appwrite project details
  static const String endpoint = 'http://localhost/v1';
  static const String projectId = 'inventory';

  // Database and collection IDs
  static const String databaseId = 'inventory_db';
  static const String productsCollectionId = 'products';
  static const String categoriesCollectionId = 'categories';
  static const String locationsCollectionId = 'locations';
  static const String inventoryItemsCollectionId = 'inventory_items';
  static const String transactionsCollectionId = 'transactions';
  static const String usersCollectionId = 'users';

  // Storage bucket IDs
  static const String productImagesStorageBucketId = 'product_images';
  static const String reportsStorageBucketId = 'reports';

  // Initialize the Appwrite client
  static Client getClient() {
    Client client = Client();
    return client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true); // For self-signed certificates in dev
  }

  // Initialize Appwrite Account
  static Account getAccount() {
    return Account(getClient());
  }

  // Initialize Appwrite Database
  static Databases getDatabases() {
    return Databases(getClient());
  }

  // Initialize Appwrite Storage
  static Storage getStorage() {
    return Storage(getClient());
  }

  // Initialize Appwrite Realtime
  static Realtime getRealtime() {
    return Realtime(getClient());
  }
}
