import 'app_exception.dart';

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}
