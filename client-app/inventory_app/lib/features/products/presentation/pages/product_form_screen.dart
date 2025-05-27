import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_event.dart';
import 'package:inventory_app/features/products/presentation/bloc/product_state.dart';
import 'package:uuid/uuid.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  final bool isDuplicate;

  const ProductFormScreen({Key? key, this.product, this.isDuplicate = false})
    : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _costController;
  late final TextEditingController _unitController;
  late final TextEditingController _imageUrlController;

  bool _isActive = true;
  String _selectedCategoryId = '';
  Map<String, dynamic> _customAttributes = {};
  bool _isSubmitting = false;

  // Dummy categories for now
  final List<Map<String, String>> _categories = [
    {'id': 'cat1', 'name': 'Electronics'},
    {'id': 'cat2', 'name': 'Clothing'},
    {'id': 'cat3', 'name': 'Food'},
    {'id': 'cat4', 'name': 'Books'},
  ];

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    // Initialize controllers with product data if we're editing
    _nameController = TextEditingController(text: product?.name ?? '');
    _skuController = TextEditingController(text: product?.sku ?? '');
    _barcodeController = TextEditingController(text: product?.barcode ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '0.00',
    );
    _costController = TextEditingController(
      text: product?.cost.toString() ?? '0.00',
    );
    _unitController = TextEditingController(text: product?.unit ?? 'pcs');
    _imageUrlController = TextEditingController(text: product?.imageUrl ?? '');

    if (product != null) {
      _isActive = product.isActive;
      _selectedCategoryId = product.categoryId;
      _customAttributes = Map.from(product.attributes);
    } else {
      // Default category
      _selectedCategoryId = _categories.first['id'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _unitController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null && !widget.isDuplicate;
    final title = isEditing ? 'Edit Product' : 'Create Product';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
            ),
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductCreated || state is ProductUpdated) {
            setState(() {
              _isSubmitting = false;
            });

            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is ProductCreated
                      ? 'Product created successfully'
                      : 'Product updated successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProductError) {
            setState(() {
              _isSubmitting = false;
            });

            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBasicInformationSection(),
                const SizedBox(height: 24),
                _buildPricingSection(),
                const SizedBox(height: 24),
                _buildInventorySection(),
                const SizedBox(height: 24),
                _buildAdvancedSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(isEditing),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBasicInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Basic Information'),

        // Product Name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name *',
            hintText: 'Enter product name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter product name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // SKU
        TextFormField(
          controller: _skuController,
          decoration: const InputDecoration(
            labelText: 'SKU *',
            hintText: 'Enter stock keeping unit',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter SKU';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Barcode
        TextFormField(
          controller: _barcodeController,
          decoration: const InputDecoration(
            labelText: 'Barcode',
            hintText: 'Enter barcode (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Description
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter product description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),

        // Image URL
        TextFormField(
          controller: _imageUrlController,
          decoration: const InputDecoration(
            labelText: 'Image URL',
            hintText: 'Enter URL to product image',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Category
        DropdownButtonFormField<String>(
          value: _selectedCategoryId.isNotEmpty ? _selectedCategoryId : null,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
          items:
              _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['id'],
                  child: Text(category['name'] ?? ''),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategoryId = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Pricing'),

        // Price
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Selling Price *',
            hintText: 'Enter selling price',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter price';
            }
            try {
              final price = double.parse(value);
              if (price < 0) {
                return 'Price cannot be negative';
              }
            } catch (e) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Cost
        TextFormField(
          controller: _costController,
          decoration: const InputDecoration(
            labelText: 'Cost *',
            hintText: 'Enter product cost',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter cost';
            }
            try {
              final cost = double.parse(value);
              if (cost < 0) {
                return 'Cost cannot be negative';
              }
            } catch (e) {
              return 'Please enter a valid cost';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInventorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Inventory'),

        // Unit
        TextFormField(
          controller: _unitController,
          decoration: const InputDecoration(
            labelText: 'Unit *',
            hintText: 'e.g., pcs, kg, lb',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter unit';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Advanced'),

        // Active Status
        SwitchListTile(
          title: const Text('Active'),
          subtitle: const Text('Inactive products won\'t appear in inventory'),
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),

        // Custom Attributes
        ExpansionTile(
          title: const Text('Custom Attributes'),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _customAttributes.length,
              itemBuilder: (context, index) {
                final entry = _customAttributes.entries.elementAt(index);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _customAttributes.remove(entry.key);
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Attribute'),
              onPressed: () => _showAddAttributeDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isEditing) {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : () => _submitForm(isEditing),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child:
          _isSubmitting
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(isEditing ? 'Update Product' : 'Create Product'),
    );
  }

  void _showAddAttributeDialog(BuildContext context) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Custom Attribute'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    labelText: 'Attribute Name',
                    hintText: 'e.g., Color, Size, Material',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: 'Attribute Value',
                    hintText: 'e.g., Red, XL, Cotton',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  final key = keyController.text.trim();
                  final value = valueController.text.trim();

                  if (key.isNotEmpty && value.isNotEmpty) {
                    setState(() {
                      _customAttributes[key] = value;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('ADD'),
              ),
            ],
          ),
    );
  }

  void _submitForm(bool isEditing) {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      final price = double.tryParse(_priceController.text) ?? 0.0;
      final cost = double.tryParse(_costController.text) ?? 0.0;

      final Product product = Product(
        id: isEditing ? widget.product!.id : const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        sku: _skuController.text.trim(),
        barcode: _barcodeController.text.trim(),
        categoryId: _selectedCategoryId,
        price: price,
        cost: cost,
        unit: _unitController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        isActive: _isActive,
        attributes: _customAttributes,
        createdAt: isEditing ? widget.product!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        context.read<ProductBloc>().add(UpdateProductEvent(product: product));
      } else {
        context.read<ProductBloc>().add(CreateProductEvent(product: product));
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    if (widget.product == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${widget.product!.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductBloc>().add(
                    DeleteProductEvent(id: widget.product!.id),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);

                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.product!.name} deleted')),
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
