import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  Failure([List<dynamic> properties = const <dynamic>[]]) : super(properties);
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
