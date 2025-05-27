import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScanService {
  /// Scan a barcode using the device's camera
  /// Returns the barcode value as a string, or null if scanning was canceled
  Future<String?> scanBarcode() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Line color
        'Cancel', // Cancel button text
        true, // Show flash icon
        ScanMode.BARCODE, // Scan mode (BARCODE, QR)
      );

      // FlutterBarcodeScanner returns '-1' when user cancels the scan
      if (barcodeScanRes == '-1') {
        return null;
      }

      return barcodeScanRes;
    } on PlatformException catch (e) {
      print('Failed to get barcode: ${e.message}');
      return null;
    } catch (e) {
      print('Unknown error: $e');
      return null;
    }
  }

  /// Generate a barcode for a product
  /// This would typically integrate with a barcode generation library
  String generateBarcode() {
    // Simple implementation for demo purposes
    // In a real application, you'd use a proper algorithm or library
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = (timestamp % 10000).toString().padLeft(4, '0');
    return 'PROD${randomSuffix}';
  }
}
