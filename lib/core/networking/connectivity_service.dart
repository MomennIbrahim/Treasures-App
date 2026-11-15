import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:konoz/core/networking/endpoints.dart';
 
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  static const _settleDelay = Duration(milliseconds: 1500);
  static const _probeTimeout = Duration(seconds: 3);
  static final _probeHost = Uri.parse(EndPoint.domain).host;
  static const _probePort = 443;

  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Stream<bool> get onStatusChange => _connectivity.onConnectivityChanged
      .asyncMap((results) => _resolve(results, settle: true))
      .map(_remember)
      .distinct();

  Future<bool> refresh() async => _remember(
        await _resolve(await _connectivity.checkConnectivity(), settle: false),
      );

  Future<bool> _resolve(
    List<ConnectivityResult> results, {
    required bool settle,
  }) async {
    if (_hasInterface(results)) return true;

    if (settle) {
      await Future<void>.delayed(_settleDelay);
      if (_hasInterface(await _connectivity.checkConnectivity())) return true;
    }

    return _canReachServer();
  }

  Future<bool> _canReachServer() async {
    try {
      final socket = await Socket.connect(
        _probeHost,
        _probePort,
        timeout: _probeTimeout,
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _remember(bool value) {
    _isConnected = value;
    return value;
  }

  bool _hasInterface(List<ConnectivityResult> results) =>
      results.isNotEmpty &&
      results.any((result) => result != ConnectivityResult.none);
}
