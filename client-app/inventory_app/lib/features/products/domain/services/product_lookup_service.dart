import 'package:dartz/dartz.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/inventory/data/services/barcode_scan_service.dart';
import 'package:inventory_app/features/products/domain/entities/product.dart';
import 'package:inventory_app/features/products/domain/repositories/product_repository.dart';

class ProductLookupService {
  final ProductRepository productRepository;
  final BarcodeScanService barcodeScanService;

  ProductLookupService({
    required this.productRepository,
    required this.barcodeScanService,
  });

  /// Scan a barcode and look up the product in the database
  Future<Either<Failure, Product>> scanAndLookupProduct() async {
    // Scan the barcode
    final barcode = await barcodeScanService.scanBarcode();

    // If scan was canceled or failed
    if (barcode == null) {
      return Left(
        UnknownFailure(message: 'Barcode scan was canceled or failed'),
      );
    }

    // Look up the product by barcode
    return await productRepository.getProductByBarcode(barcode);
  }

  /// Generate a new barcode for a product
  String generateNewBarcode() {
    return barcodeScanService.generateBarcode();
  }

  /// Look up a product by its barcode without scanning
  Future<Either<Failure, Product>> lookupProductByBarcode(
    String barcode,
  ) async {
    return await productRepository.getProductByBarcode(barcode);
  }
}
