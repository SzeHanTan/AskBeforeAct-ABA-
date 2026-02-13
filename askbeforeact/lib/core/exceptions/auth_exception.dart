import 'app_exception.dart';

/// Authentication-related exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code});
}
