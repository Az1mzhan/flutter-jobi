class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final int? code;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Сессия истекла. Войдите снова.'])
      : super(code: 401);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Сейчас не удается подключиться к серверу.']);
}
