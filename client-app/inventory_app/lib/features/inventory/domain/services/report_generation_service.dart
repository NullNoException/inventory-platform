import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/inventory/domain/entities/transaction.dart';
import 'package:inventory_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';
import 'package:inventory_app/features/inventory/domain/repositories/transaction_repository.dart';

class ReportGenerationService {
  final ProductRepository productRepository;
  final InventoryRepository inventoryRepository;
  final TransactionRepository transactionRepository;

  ReportGenerationService({
    required this.productRepository,
    required this.inventoryRepository,
    required this.transactionRepository,
  });

  /// Generate an inventory stock report with all current inventory levels
  Future<Either<Failure, File>> generateInventoryStockReport() async {
    try {
      // Fetch all inventory items
      final inventoryResult = await inventoryRepository.getAllInventoryItems();

      return await inventoryResult.fold((failure) => Left(failure), (
        inventoryItems,
      ) async {
        // Fetch all products for more details
        final productsResult = await productRepository.getAllProducts();

        return await productsResult.fold((failure) => Left(failure), (
          products,
        ) async {
          // Create a PDF document
          final pdf = pw.Document();

          // Add a title page
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Inventory Stock Report',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Generated on: ${DateTime.now().toString().substring(0, 16)}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Total Items: ${inventoryItems.length}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          // Create a map of products by ID for easy lookup
          final productMap = {
            for (var product in products) product.id: product,
          };

          // Add inventory data page
          pdf.addPage(
            pw.MultiPage(
              header: (pw.Context context) {
                return pw.Text(
                  'Inventory Stock Report - ${DateTime.now().toString().substring(0, 10)}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                );
              },
              build: (pw.Context context) {
                return [
                  pw.Table.fromTextArray(
                    headers: [
                      'Product',
                      'SKU',
                      'Location',
                      'Quantity',
                      'Min Qty',
                      'Status',
                    ],
                    data:
                        inventoryItems.map((item) {
                          final product =
                              productMap[item.productId] ??
                              Product(
                                id: '',
                                name: 'Unknown',
                                description: '',
                                sku: '',
                                barcode: '',
                                categoryId: '',
                                price: 0,
                                cost: 0,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );

                          String status = 'OK';
                          if (item.isLowStock) {
                            status = 'LOW STOCK';
                          } else if (item.isOverStocked) {
                            status = 'OVER STOCKED';
                          } else if (item.hasExpired) {
                            status = 'EXPIRED';
                          } else if (item.isExpiringSoon) {
                            status = 'EXPIRING SOON';
                          }

                          return [
                            product.name,
                            product.sku,
                            item.locationId,
                            item.quantity.toString(),
                            item.minQuantity.toString(),
                            status,
                          ];
                        }).toList(),
                    cellAlignment: pw.Alignment.center,
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellHeight: 30,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft, // Product name
                      1: pw.Alignment.center, // SKU
                      2: pw.Alignment.center, // Location
                      3: pw.Alignment.centerRight, // Quantity
                      4: pw.Alignment.centerRight, // Min Qty
                      5: pw.Alignment.center, // Status
                    },
                  ),
                ];
              },
            ),
          );

          // Save the PDF
          final output = await getTemporaryDirectory();
          final file = File(
            '${output.path}/inventory_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
          );
          await file.writeAsBytes(await pdf.save());

          return Right(file);
        });
      });
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Generate a transaction history report for a specified date range
  Future<Either<Failure, File>> generateTransactionReport(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Fetch transactions in the date range
      final transactionsResult = await transactionRepository
          .getTransactionsByDateRange(startDate, endDate);

      return await transactionsResult.fold((failure) => Left(failure), (
        transactions,
      ) async {
        // Fetch all products for more details
        final productsResult = await productRepository.getAllProducts();

        return await productsResult.fold((failure) => Left(failure), (
          products,
        ) async {
          // Create a PDF document
          final pdf = pw.Document();

          // Add a title page
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Transaction History Report',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Date Range: ${startDate.toString().substring(0, 10)} to ${endDate.toString().substring(0, 10)}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Total Transactions: ${transactions.length}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          // Create a map of products by ID for easy lookup
          final productMap = {
            for (var product in products) product.id: product,
          };

          // Add transaction data page
          pdf.addPage(
            pw.MultiPage(
              header: (pw.Context context) {
                return pw.Text(
                  'Transaction Report (${startDate.toString().substring(0, 10)} - ${endDate.toString().substring(0, 10)})',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                );
              },
              build: (pw.Context context) {
                return [
                  pw.Table.fromTextArray(
                    headers: [
                      'Date',
                      'Product',
                      'Type',
                      'Quantity',
                      'From',
                      'To',
                      'Reference',
                    ],
                    data:
                        transactions.map((transaction) {
                          final product =
                              productMap[transaction.productId] ??
                              Product(
                                id: '',
                                name: 'Unknown',
                                description: '',
                                sku: '',
                                barcode: '',
                                categoryId: '',
                                price: 0,
                                cost: 0,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );

                          return [
                            transaction.transactionDate.toString().substring(
                              0,
                              16,
                            ),
                            product.name,
                            transaction.type.toString().split('.').last,
                            transaction.quantity.toString(),
                            transaction.sourceLocationId,
                            transaction.destinationLocationId,
                            transaction.referenceNumber,
                          ];
                        }).toList(),
                    cellAlignment: pw.Alignment.center,
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellHeight: 30,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft, // Date
                      1: pw.Alignment.centerLeft, // Product
                      2: pw.Alignment.center, // Type
                      3: pw.Alignment.centerRight, // Quantity
                      4: pw.Alignment.center, // From
                      5: pw.Alignment.center, // To
                      6: pw.Alignment.centerLeft, // Reference
                    },
                  ),
                ];
              },
            ),
          );

          // Save the PDF
          final output = await getTemporaryDirectory();
          final file = File(
            '${output.path}/transaction_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
          );
          await file.writeAsBytes(await pdf.save());

          return Right(file);
        });
      });
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Generate a low stock alert report
  Future<Either<Failure, File>> generateLowStockReport() async {
    try {
      // Fetch low stock items
      final lowStockResult = await inventoryRepository.getLowStockItems();

      return await lowStockResult.fold((failure) => Left(failure), (
        lowStockItems,
      ) async {
        if (lowStockItems.isEmpty) {
          return Left(UnknownFailure(message: 'No low stock items found'));
        }

        // Fetch all products for more details
        final productsResult = await productRepository.getAllProducts();

        return await productsResult.fold((failure) => Left(failure), (
          products,
        ) async {
          // Create a PDF document
          final pdf = pw.Document();

          // Add a title page
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Low Stock Alert Report',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Generated on: ${DateTime.now().toString().substring(0, 16)}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Items Requiring Attention: ${lowStockItems.length}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

          // Create a map of products by ID for easy lookup
          final productMap = {
            for (var product in products) product.id: product,
          };

          // Add low stock data page
          pdf.addPage(
            pw.MultiPage(
              header: (pw.Context context) {
                return pw.Text(
                  'Low Stock Alert Report - ${DateTime.now().toString().substring(0, 10)}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                );
              },
              build: (pw.Context context) {
                return [
                  pw.Table.fromTextArray(
                    headers: [
                      'Product',
                      'SKU',
                      'Location',
                      'Current Qty',
                      'Min Qty',
                      'Reorder Amount',
                    ],
                    data:
                        lowStockItems.map((item) {
                          final product =
                              productMap[item.productId] ??
                              Product(
                                id: '',
                                name: 'Unknown',
                                description: '',
                                sku: '',
                                barcode: '',
                                categoryId: '',
                                price: 0,
                                cost: 0,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );

                          // Calculate suggested reorder amount
                          final reorderAmount =
                              item.minQuantity > item.quantity
                                  ? (item.minQuantity - item.quantity)
                                  : 0;

                          return [
                            product.name,
                            product.sku,
                            item.locationId,
                            item.quantity.toString(),
                            item.minQuantity.toString(),
                            reorderAmount.toString(),
                          ];
                        }).toList(),
                    cellAlignment: pw.Alignment.center,
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellHeight: 30,
                    cellAlignments: {
                      0: pw.Alignment.centerLeft, // Product
                      1: pw.Alignment.center, // SKU
                      2: pw.Alignment.center, // Location
                      3: pw.Alignment.centerRight, // Current Qty
                      4: pw.Alignment.centerRight, // Min Qty
                      5: pw.Alignment.centerRight, // Reorder Amount
                    },
                  ),
                ];
              },
            ),
          );

          // Save the PDF
          final output = await getTemporaryDirectory();
          final file = File(
            '${output.path}/low_stock_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
          );
          await file.writeAsBytes(await pdf.save());

          return Right(file);
        });
      });
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Share a report file
  Future<void> shareReport(File reportFile) async {
    try {
      await Share.shareXFiles(
        [XFile(reportFile.path)],
        subject: 'Inventory Report',
        text: 'Please find the attached inventory report',
      );
    } catch (e) {
      print('Error sharing report: $e');
    }
  }
}
