import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';

abstract class NetWorkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetWorkInfo {
  DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl({
    this.dataConnectionChecker,
  });

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
