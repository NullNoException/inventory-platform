part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadInventoryItems extends InventoryEvent {}

class LoadLowStockItems extends InventoryEvent {}

class ScanProductBarcode extends InventoryEvent {}

class AdjustInventoryQuantity extends InventoryEvent {
  final String productId;
  final String locationId;
  final int quantityChange;
  final String reason;

  const AdjustInventoryQuantity({
    required this.productId,
    required this.locationId,
    required this.quantityChange,
    required this.reason,
  });

  @override
  List<Object> get props => [productId, locationId, quantityChange, reason];
}

class RecordStockTake extends InventoryEvent {
  final String productId;
  final String locationId;
  final int newQuantity;
  final String notes;

  const RecordStockTake({
    required this.productId,
    required this.locationId,
    required this.newQuantity,
    required this.notes,
  });

  @override
  List<Object> get props => [productId, locationId, newQuantity, notes];
}

class SearchProducts extends InventoryEvent {
  final String searchTerm;

  const SearchProducts({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}
