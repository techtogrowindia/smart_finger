import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final res = await repository.login(email, password);

      if (res.statusCode == 200) {
        emit(LoginSuccess(res));
      } else {
        emit(LoginFailure(res.message ?? 'Login failed'));
      }
    } on SocketException catch (_) {
      emit(LoginFailure("NO_INTERNET"));
    } catch (e) {
      emit(LoginFailure("Something went wrong"));
    }
  }
}
