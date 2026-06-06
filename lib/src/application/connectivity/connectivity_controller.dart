import 'dart:async';
import 'package:customer_core/src/infrastructure/connectivity/connectivity_source.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController {
  ConnectivityController._();

  static final ConnectivityController instance = ConnectivityController._();

  final _dataSource = ConnectivityDataSource();

  final ValueNotifier<bool> isOnline = ValueNotifier(true);

  StreamSubscription? _subscription;

  Future<void> init() async {
    final result = await _dataSource.check();
    isOnline.value = _isOnline(result);

    _subscription = _dataSource.stream.listen((result) {
      isOnline.value = _isOnline(result);
    });
  }

  bool _isOnline(List<ConnectivityResult> result) {
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> retry() async {
    final result = await _dataSource.check();
    isOnline.value = _isOnline(result);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
