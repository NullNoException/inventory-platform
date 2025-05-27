import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/core/di/service_locator.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_event.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_state.dart';
import 'package:inventory_app/features/products/presentation/pages/product_form_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductById(id: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed:
                      () => _navigateToEditProduct(context, state.product),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return _buildProductDetails(context, state.product);
          } else if (state is ProductError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('Product not found'));
        },
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (product.imageUrl.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Icon(Icons.inventory_2, size: 50),
            ),
          const SizedBox(height: 20),

          // Product name
          Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),

          // Pricing information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pricing',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Sale Price',
                    '\$${product.price.toStringAsFixed(2)}',
                  ),
                  _buildInfoRow('Cost', '\$${product.cost.toStringAsFixed(2)}'),
                  _buildInfoRow(
                    'Margin',
                    '\$${(product.price - product.cost).toStringAsFixed(2)}',
                  ),
                  _buildInfoRow(
                    'Margin %',
                    '${((product.price - product.cost) / product.price * 100).toStringAsFixed(2)}%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow('SKU', product.sku),
                  _buildInfoRow('Barcode', product.barcode),
                  _buildInfoRow('Unit', product.unit),
                  _buildInfoRow(
                    'Status',
                    product.isActive ? 'Active' : 'Inactive',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Custom attributes
          if (product.attributes.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attributes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    ...product.attributes.entries.map((entry) {
                      return _buildInfoRow(entry.key, entry.value.toString());
                    }).toList(),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Timestamp information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow('Created', _formatDateTime(product.createdAt)),
                  _buildInfoRow(
                    'Last Updated',
                    _formatDateTime(product.updatedAt),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                icon: Icons.edit,
                label: 'Edit',
                onPressed: () => _navigateToEditProduct(context, product),
                color: Colors.blue,
              ),
              _buildActionButton(
                context,
                icon: Icons.content_copy,
                label: 'Duplicate',
                onPressed: () => _duplicateProduct(context, product),
                color: Colors.green,
              ),
              _buildActionButton(
                context,
                icon: Icons.delete,
                label: 'Delete',
                onPressed: () => _showDeleteConfirmation(context, product),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _navigateToEditProduct(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: sl<ProductBloc>(),
              child: ProductFormScreen(product: product),
            ),
      ),
    ).then((_) {
      // Refresh product details when returning from edit screen
      context.read<ProductBloc>().add(LoadProductById(id: widget.productId));
    });
  }

  void _duplicateProduct(BuildContext context, Product product) {
    // Create a copy of the product with a placeholder ID and adjusted name
    final newProduct = Product(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      name: '${product.name} (Copy)',
      description: product.description,
      sku: '${product.sku}-COPY',
      barcode: product.barcode,
      categoryId: product.categoryId,
      price: product.price,
      cost: product.cost,
      unit: product.unit,
      imageUrl: product.imageUrl,
      isActive: product.isActive,
      attributes: Map.from(product.attributes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: sl<ProductBloc>(),
              child: ProductFormScreen(product: newProduct, isDuplicate: true),
            ),
      ),
    ).then((_) {
      // Refresh product details when returning from the duplicate form
      context.read<ProductBloc>().add(LoadProductById(id: widget.productId));
    });
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                    DeleteProductEvent(id: product.id),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to product list

                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          // This would typically restore the product
                          // For simplicity, we'll just show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product restore not implemented'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text('DELETE'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}
