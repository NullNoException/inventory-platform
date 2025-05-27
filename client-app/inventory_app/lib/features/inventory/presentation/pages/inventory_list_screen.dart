import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/inventory_list_item.dart';
import 'package:inventory_app/features/inventory/presentation/widgets/product_scan_result.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({Key? key}) : super(key: key);

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Load inventory items when screen initializes
    context.read<InventoryBloc>().add(LoadInventoryItems());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // Trigger barcode scanning
              context.read<InventoryBloc>().add(ScanProductBarcode());
            },
            tooltip: 'Scan Barcode',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // Reload all items
                    context.read<InventoryBloc>().add(LoadInventoryItems());
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<InventoryBloc>().add(
                    SearchProducts(searchTerm: value),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<InventoryBloc, InventoryState>(
              listener: (context, state) {
                if (state is InventoryError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is ProductScanError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is ProductScanned) {
                  _showProductDetails(
                    context,
                    state.product,
                    state.inventoryItems,
                  );
                } else if (state is InventoryAdjusted ||
                    state is StockTakeRecorded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Inventory updated successfully'),
                    ),
                  );
                  // Reload inventory items
                  context.read<InventoryBloc>().add(LoadInventoryItems());
                }
              },
              builder: (context, state) {
                if (state is InventoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is InventoryLoaded) {
                  return _buildInventoryList(state.items);
                } else if (state is LowStockItemsLoaded) {
                  return _buildInventoryList(state.items, isLowStock: true);
                } else if (state is ProductsSearched) {
                  return _buildProductList(state.products);
                } else if (state is InventoryInitial) {
                  return const Center(child: Text('Loading inventory...'));
                } else {
                  return const Center(child: Text('No inventory items found'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product/inventory screen
          // Implementation will be done later
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Item',
      ),
    );
  }

  Widget _buildInventoryList(
    List<InventoryItem> items, {
    bool isLowStock = false,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          isLowStock ? 'No low stock items found' : 'No inventory items found',
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InventoryListItem(
          item: item,
          onAdjust: (quantity, reason) {
            context.read<InventoryBloc>().add(
              AdjustInventoryQuantity(
                productId: item.productId,
                locationId: item.locationId,
                quantityChange: quantity,
                reason: reason,
              ),
            );
          },
          onStockTake: (newQuantity, notes) {
            context.read<InventoryBloc>().add(
              RecordStockTake(
                productId: item.productId,
                locationId: item.locationId,
                newQuantity: newQuantity,
                notes: notes,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text(product.sku),
          trailing: Text('\$${product.price.toStringAsFixed(2)}'),
          onTap: () {
            // Navigate to product detail screen
            // Implementation will be done later
          },
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: const Text('All Items'),
              onTap: () {
                Navigator.pop(context);
                context.read<InventoryBloc>().add(LoadInventoryItems());
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text('Low Stock Items'),
              onTap: () {
                Navigator.pop(context);
                context.read<InventoryBloc>().add(LoadLowStockItems());
              },
            ),
            // Additional filters can be added here
          ],
        );
      },
    );
  }

  void _showProductDetails(
    BuildContext context,
    Product product,
    List<InventoryItem> inventoryItems,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ProductScanResult(
          product: product,
          inventoryItems: inventoryItems,
          onAdjust: (productId, locationId, quantity, reason) {
            Navigator.pop(context);
            context.read<InventoryBloc>().add(
              AdjustInventoryQuantity(
                productId: productId,
                locationId: locationId,
                quantityChange: quantity,
                reason: reason,
              ),
            );
          },
        );
      },
    );
  }
}
