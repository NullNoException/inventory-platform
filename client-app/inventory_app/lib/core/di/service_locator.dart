import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/config/appwrite_config.dart';
import 'package:inventory_app/core/network/network_info.dart';
import 'package:inventory_app/core/network/sync_service.dart';
import 'package:inventory_app/core/storage/local_storage_service.dart';
import 'package:inventory_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:inventory_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:inventory_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:inventory_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:inventory_app/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/reset_password_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:inventory_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:inventory_app/features/products/domain/usecases/delete_product.dart';
import 'package:inventory_app/features/products/domain/usecases/update_product.dart';
import 'package:inventory_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';
import 'package:inventory_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:inventory_app/features/products/domain/usecases/get_all_products.dart';
import 'package:inventory_app/features/products/domain/usecases/get_product_by_id.dart';
import 'package:inventory_app/features/products/domain/usecases/get_products_by_category.dart';
import 'package:inventory_app/features/products/domain/usecases/search_products.dart';
import 'package:inventory_app/features/products/domain/usecases/create_product.dart';

final GetIt sl = GetIt.instance;

/// Sets up the service locator for the application
Future<void> setupLocator() async {
  // Core
  _setupCoreServices();

  // Features
  _setupAuthenticationServices();
  _setupProductServices();
  _setupInventoryServices();
  _setupReportingServices();
  _setupNotificationServices();
  _setupScanningServices();
}

void _setupCoreServices() {
  // External
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Appwrite clients
  sl.registerLazySingleton<Client>(() => AppwriteConfig.getClient());
  sl.registerLazySingleton<Account>(() => AppwriteConfig.getAccount());
  sl.registerLazySingleton<Databases>(() => AppwriteConfig.getDatabases());
  sl.registerLazySingleton<Storage>(() => AppwriteConfig.getStorage());
  sl.registerLazySingleton<Realtime>(() => AppwriteConfig.getRealtime());

  // Core services
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  sl.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(),
  );
  sl.registerLazySingleton<SyncService>(
    () => SyncServiceImpl(storageService: sl(), networkInfo: sl()),
  );
}

void _setupAuthenticationServices() {
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storageService: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      account: sl(),
      databases: sl(),
      usersCollectionId: AppwriteConfig.usersCollectionId,
      databaseId: AppwriteConfig.databaseId,
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
}

void _setupProductServices() {
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // BLoC
  sl.registerFactory(
    () => ProductBloc(
      getAllProducts: sl(),
      getProductById: sl(),
      getProductsByCategory: sl(),
      searchProducts: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
    ),
  );
}

void _setupInventoryServices() {
  // TODO: Set up inventory services
}

void _setupReportingServices() {
  // TODO: Set up reporting services
}

void _setupNotificationServices() {
  // TODO: Set up notification services
}

void _setupScanningServices() {
  // TODO: Set up scanning services
}
