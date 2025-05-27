import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectionStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final BehaviorSubject<bool> _connectionStatusController =
      BehaviorSubject<bool>();

  NetworkInfoImpl({required this.connectivity}) {
    // Initialize and listen to connection changes
    connectivity.onConnectivityChanged.listen((result) {
      _checkAndUpdateStatus(result);
    });

    // Check initial status
    _initConnectionStatus();
  }

  Future<void> _initConnectionStatus() async {
    final connectivityResult = await connectivity.checkConnectivity();
    _checkAndUpdateStatus(connectivityResult);
  }

  void _checkAndUpdateStatus(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    _connectionStatusController.add(isConnected);
  }

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Stream<bool> get connectionStream => _connectionStatusController.stream;

  void dispose() {
    _connectionStatusController.close();
  }
}
