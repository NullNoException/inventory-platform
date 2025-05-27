import 'package:flutter/material.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';

class InventoryListItem extends StatelessWidget {
  final InventoryItem item;
  final Function(int quantity, String reason) onAdjust;
  final Function(int newQuantity, String notes) onStockTake;

  const InventoryListItem({
    Key? key,
    required this.item,
    required this.onAdjust,
    required this.onStockTake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Product ID: ${item.productId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
            const SizedBox(height: 8),
            Text('Location: ${item.locationId}'),
            Text('Quantity: ${item.quantity}'),
            Text('Min Quantity: ${item.minQuantity}'),
            if (item.expiryDate != null)
              Text(
                'Expires: ${item.expiryDate!.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                  color: item.hasExpired ? Colors.red : Colors.black,
                  fontWeight:
                      item.hasExpired ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showAdjustDialog(context),
                  child: const Text('Adjust'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showStockTakeDialog(context),
                  child: const Text('Stock Take'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
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

  void _showAdjustDialog(BuildContext context) {
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adjust Inventory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Quantity: ${item.quantity}'),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Change Amount (+ or -)',
                  hintText: 'Enter positive or negative number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  hintText: 'Enter reason for adjustment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantityText = quantityController.text;
                final reason = reasonController.text;

                if (quantityText.isNotEmpty && reason.isNotEmpty) {
                  final quantity = int.tryParse(quantityText);
                  if (quantity != null) {
                    Navigator.pop(context);
                    onAdjust(quantity, reason);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showStockTakeDialog(BuildContext context) {
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Record Stock Take'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Recorded Quantity: ${item.quantity}'),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Actual Quantity',
                  hintText: 'Enter the counted quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Enter any observations',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantityText = quantityController.text;
                final notes = notesController.text;

                if (quantityText.isNotEmpty) {
                  final newQuantity = int.tryParse(quantityText);
                  if (newQuantity != null) {
                    Navigator.pop(context);
                    onStockTake(newQuantity, notes);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
