part of 'inventory_bloc.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError({required this.message});

  @override
  List<Object> get props => [message];
}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> items;

  const InventoryLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class LowStockItemsLoaded extends InventoryState {
  final List<InventoryItem> items;

  const LowStockItemsLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class ProductScanned extends InventoryState {
  final Product product;
  final List<InventoryItem> inventoryItems;

  const ProductScanned({required this.product, required this.inventoryItems});

  @override
  List<Object> get props => [product, inventoryItems];
}

class ProductScanError extends InventoryState {
  final String message;

  const ProductScanError({required this.message});

  @override
  List<Object> get props => [message];
}

class InventoryAdjusted extends InventoryState {
  final InventoryItem item;

  const InventoryAdjusted({required this.item});

  @override
  List<Object> get props => [item];
}

class StockTakeRecorded extends InventoryState {
  final InventoryItem item;

  const StockTakeRecorded({required this.item});

  @override
  List<Object> get props => [item];
}

class ProductsSearched extends InventoryState {
  final List<Product> products;

  const ProductsSearched({required this.products});

  @override
  List<Object> get props => [products];
}
