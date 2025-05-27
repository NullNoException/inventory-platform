// Exception types that can occur in the app

class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({required this.message});
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({required this.message});
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  ValidationException({required this.message, this.errors});
}

class PermissionException implements Exception {
  final String message;

  PermissionException({required this.message});
}

class UnknownException implements Exception {
  final String message;

  UnknownException({required this.message});
}
