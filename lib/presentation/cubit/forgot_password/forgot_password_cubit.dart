import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/forgot_password_repository.dart';
import 'package:smart_finger/presentation/cubit/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordCubit(this.repository) : super(ForgotPasswordInitial());

  Future<void> forgotPassword(String mobile, String password) async {
    emit(ForgotPasswordLoading());

    try {
      final res = await repository.forgotPassword(mobile, password);

      if (res == 'Password updated successfully.') {
        emit(ForgotPasswordSuccess(res));
      } else {
        emit(ForgotPasswordFailure(res));
      }
    } on SocketException catch (_) {
      emit(ForgotPasswordFailure("NO_INTERNET"));
    } catch (e) {
      emit(ForgotPasswordFailure("Something went wrong"));
    }
  }
}
