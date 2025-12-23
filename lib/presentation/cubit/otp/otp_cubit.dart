import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/otp_repository.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;

  OtpCubit(this.repository) : super(OtpInitial());

  Future<void> sendOtp(String mobile) async {
    emit(OtpLoading());
    try {
      await repository.sendOtp(mobile);
      emit(OtpSent());
    } on SocketException {
      emit(OtpError("NO_INTERNET"));
    } catch (_) {
      emit(OtpError("OTP sending failed"));
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(VerifyOtpLoading());
    try {
      final res = await repository.verifyOtp(otp);

      if (res.status == 200) {
        emit(OtpVerified(res.message));
      } else {
        emit(VerifyOtpError(res.message));
      }
    } on SocketException {
      emit(VerifyOtpError("NO_INTERNET"));
    } catch (_) {
      emit(VerifyOtpError("Invalid OTP"));
    }
  }

  void reset() {
    emit(OtpInitial());
  }
}
