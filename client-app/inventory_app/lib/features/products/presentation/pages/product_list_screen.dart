import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_event.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_state.dart';
import 'package:inventory_app/features/products/presentation/pages/product_details_screen.dart';
import 'package:inventory_app/features/products/presentation/pages/product_form_screen.dart';
import 'package:inventory_app/shared/presentation/widgets/error_view.dart';
import 'package:inventory_app/shared/presentation/widgets/loading_view.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = '';
  bool _showActiveOnly = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    context.read<ProductBloc>().add(LoadProducts());
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      _loadProducts();
    } else {
      context.read<ProductBloc>().add(SearchProducts(searchTerm: query));
    }
  }

  void _filterByCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });

    if (categoryId.isEmpty) {
      _loadProducts();
    } else {
      context.read<ProductBloc>().add(
        LoadProductsByCategory(categoryId: categoryId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProducts),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search products...',
              onChanged: _searchProducts,
              trailing: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadProducts();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const LoadingView();
                } else if (state is ProductError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: _loadProducts,
                  );
                } else if (state is ProductsLoaded) {
                  final products = state.products;

                  // Apply active-only filter if enabled
                  final filteredProducts =
                      _showActiveOnly
                          ? products.where((p) => p.isActive).toList()
                          : products;

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                            onPressed: () => _navigateToProductForm(context),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadProducts(),
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildProductItem(context, product);
                      },
                    ),
                  );
                }

                return const LoadingView();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProductForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading:
            product.imageUrl.isNotEmpty
                ? CircleAvatar(
                  backgroundImage: NetworkImage(product.imageUrl),
                  onBackgroundImageError: (_, __) {},
                  child: const Icon(Icons.inventory_2),
                )
                : const CircleAvatar(child: Icon(Icons.inventory_2)),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: product.isActive ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${product.sku}'),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)} | Cost: \$${product.cost.toStringAsFixed(2)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!product.isActive)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text('Inactive'),
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed:
                  () => _navigateToProductForm(context, product: product),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showProductOptions(context, product),
            ),
          ],
        ),
        onTap: () => _navigateToProductDetail(context, product),
      ),
    );
  }

  void _navigateToProductDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: product.id),
      ),
    ).then((_) => _loadProducts());
  }

  void _navigateToProductForm(BuildContext context, {Product? product}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    ).then((_) => _loadProducts());
  }

  void _showProductOptions(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProductDetail(context, product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Product'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToProductForm(context, product: product);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Duplicate Product'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductFormScreen(
                            product: product,
                            isDuplicate: true,
                          ),
                    ),
                  ).then((_) => _loadProducts());
                },
              ),
              ListTile(
                leading: Icon(
                  product.isActive ? Icons.visibility_off : Icons.visibility,
                  color: product.isActive ? Colors.red : Colors.green,
                ),
                title: Text(
                  product.isActive ? 'Mark as Inactive' : 'Mark as Active',
                  style: TextStyle(
                    color: product.isActive ? Colors.red : Colors.green,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  final updatedProduct = product.copyWith(
                    isActive: !product.isActive,
                    updatedAt: DateTime.now(),
                  );
                  context.read<ProductBloc>().add(
                    UpdateProductEvent(product: updatedProduct),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Product',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, product);
                },
              ),
            ],
          ),
    );
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
                  Navigator.pop(context);
                  context.read<ProductBloc>().add(
                    DeleteProductEvent(id: product.id),
                  );

                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} deleted')),
                  );
                },
                child: const Text('DELETE'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // Placeholder categories for now
    final categories = [
      {'id': '', 'name': 'All Categories'},
      {'id': 'cat1', 'name': 'Electronics'},
      {'id': 'cat2', 'name': 'Clothing'},
      {'id': 'cat3', 'name': 'Food'},
      {'id': 'cat4', 'name': 'Books'},
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Products'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Category'),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategoryId,
                  items:
                      categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'],
                          child: Text(category['name'] ?? ''),
                        );
                      }).toList(),
                  onChanged: (value) {
                    Navigator.pop(context);
                    if (value != null) {
                      _filterByCategory(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Show active products only'),
                  value: _showActiveOnly,
                  onChanged: (value) {
                    Navigator.pop(context);
                    setState(() {
                      _showActiveOnly = value ?? true;
                    });
                    _loadProducts();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedCategoryId = '';
                    _showActiveOnly = true;
                  });
                  _loadProducts();
                },
                child: const Text('RESET FILTERS'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ],
          ),
    );
  }
}
