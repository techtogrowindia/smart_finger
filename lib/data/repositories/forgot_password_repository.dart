
import 'package:smart_finger/data/services/forgot_password_service.dart';


class ForgotPasswordRepository {
  final ForgotPasswordService service;

  ForgotPasswordRepository(this.service);

  Future<String> forgotPassword(String mobile, String password) {
    return service.forgotPassword(mobile, password);
  }
}
