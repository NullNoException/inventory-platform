import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';

class ProductScanResult extends StatefulWidget {
  final Product product;
  final List<InventoryItem> inventoryItems;
  final Function(
    String productId,
    String locationId,
    int quantity,
    String reason,
  )
  onAdjust;

  const ProductScanResult({
    Key? key,
    required this.product,
    required this.inventoryItems,
    required this.onAdjust,
  }) : super(key: key);

  @override
  State<ProductScanResult> createState() => _ProductScanResultState();
}

class _ProductScanResultState extends State<ProductScanResult> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedLocationId;

  @override
  void initState() {
    super.initState();
    // Select the first location if available
    if (widget.inventoryItems.isNotEmpty) {
      _selectedLocationId = widget.inventoryItems.first.locationId;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('SKU: ${widget.product.sku}'),
            Text('Barcode: ${widget.product.barcode}'),
            Text('Price: \$${widget.product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Inventory Locations:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (widget.inventoryItems.isEmpty)
              const Text('No inventory locations found for this product')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.inventoryItems.length,
                itemBuilder: (context, index) {
                  final item = widget.inventoryItems[index];
                  return ListTile(
                    title: Text('Location: ${item.locationId}'),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: _buildStatusChip(item),
                  );
                },
              ),
            const SizedBox(height: 16),
            const Text(
              'Quick Adjustment:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLocationId,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              items:
                  widget.inventoryItems.map((item) {
                    return DropdownMenuItem<String>(
                      value: item.locationId,
                      child: Text(item.locationId),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocationId = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity Change (+ or -)',
                hintText: 'Enter positive or negative number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'Enter reason for adjustment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleAdjust,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Submit Adjustment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(InventoryItem item) {
    String label = '';
    Color color = Colors.green;

    if (item.isLowStock) {
      label = 'LOW STOCK';
      color = Colors.orange;
    } else if (item.isOverStocked) {
      label = 'OVER STOCKED';
      color = Colors.blue;
    } else if (item.hasExpired) {
      label = 'EXPIRED';
      color = Colors.red;
    } else if (item.isExpiringSoon) {
      label = 'EXPIRING SOON';
      color = Colors.amber;
    } else {
      label = 'IN STOCK';
      color = Colors.green;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _handleAdjust() {
    if (_selectedLocationId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a location')));
      return;
    }

    final quantityText = _quantityController.text;
    final reason = _reasonController.text;

    if (quantityText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a quantity')));
      return;
    }

    if (reason.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a reason')));
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    widget.onAdjust(widget.product.id, _selectedLocationId!, quantity, reason);
  }
}
