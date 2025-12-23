
import 'package:smart_finger/data/models/login_response.dart';
import 'package:smart_finger/data/services/login_service.dart';


class LoginRepository {
  final LoginService service;

  LoginRepository(this.service);

  Future<LoginResponse> login(String email, String password) {
    return service.login(email, password);
  }
}
