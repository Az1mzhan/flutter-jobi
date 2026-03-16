class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final int? code;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    String message = 'Session expired. Please sign in again.',
  ]) : super(message, code: 401);
}

class NetworkException extends AppException {
  const NetworkException([
    String message = 'Unable to reach the server right now.',
  ]) : super(message);
}
