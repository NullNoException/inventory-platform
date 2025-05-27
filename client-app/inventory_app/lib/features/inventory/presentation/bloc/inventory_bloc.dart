import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';
import 'package:inventory_app/features/products/domain/services/product_lookup_service.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository inventoryRepository;
  final ProductRepository productRepository;
  final ProductLookupService productLookupService;

  InventoryBloc({
    required this.inventoryRepository,
    required this.productRepository,
    required this.productLookupService,
  }) : super(InventoryInitial()) {
    on<LoadInventoryItems>(_onLoadInventoryItems);
    on<LoadLowStockItems>(_onLoadLowStockItems);
    on<ScanProductBarcode>(_onScanProductBarcode);
    on<AdjustInventoryQuantity>(_onAdjustInventoryQuantity);
    on<RecordStockTake>(_onRecordStockTake);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadInventoryItems(
    LoadInventoryItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await inventoryRepository.getAllInventoryItems();

    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (items) => emit(InventoryLoaded(items: items)),
    );
  }

  Future<void> _onLoadLowStockItems(
    LoadLowStockItems event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await inventoryRepository.getLowStockItems();

    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (items) => emit(LowStockItemsLoaded(items: items)),
    );
  }

  Future<void> _onScanProductBarcode(
    ScanProductBarcode event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final productResult = await productLookupService.scanAndLookupProduct();

    await productResult.fold(
      (failure) {
        emit(ProductScanError(message: failure.message));
      },
      (product) async {
        // Get inventory items for this product
        final inventoryResult = await inventoryRepository
            .getInventoryItemsByProduct(product.id);

        inventoryResult.fold(
          (failure) => emit(InventoryError(message: failure.message)),
          (items) =>
              emit(ProductScanned(product: product, inventoryItems: items)),
        );
      },
    );
  }

  Future<void> _onAdjustInventoryQuantity(
    AdjustInventoryQuantity event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await inventoryRepository.adjustInventory(
      event.productId,
      event.locationId,
      event.quantityChange,
      event.reason,
    );

    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (updatedItem) => emit(InventoryAdjusted(item: updatedItem)),
    );
  }

  Future<void> _onRecordStockTake(
    RecordStockTake event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await inventoryRepository.recordStockTake(
      event.productId,
      event.locationId,
      event.newQuantity,
      event.notes,
    );

    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (updatedItem) => emit(StockTakeRecorded(item: updatedItem)),
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    final result = await productRepository.searchProducts(event.searchTerm);

    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (products) => emit(ProductsSearched(products: products)),
    );
  }
}
