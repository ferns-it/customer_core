import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityDataSource {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get stream =>
      _connectivity.onConnectivityChanged;

  Future<List<ConnectivityResult>> check() async {
    return await _connectivity.checkConnectivity();
  }
}
