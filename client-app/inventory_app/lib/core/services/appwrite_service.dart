import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';

class AppwriteService {
  late final Client client;
  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;

  AppwriteService() {
    client = AppwriteConfig.getClient();
    account = AppwriteConfig.getAccount();
    databases = AppwriteConfig.getDatabases();
    storage = AppwriteConfig.getStorage();
    realtime = AppwriteConfig.getRealtime();
  }
}
