import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({required super.message, this.errors});

  @override
  List<Object> get props => [message, if (errors != null) errors!];
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}
