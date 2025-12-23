import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';
import '../services/otp_service.dart';

class OtpRepository {
  final OtpService service;

  OtpRepository(this.service);

  Future<SendOtpResponse> sendOtp(String mobile) {
    return service.sendOtp(mobile);
  }

  Future<VerifyOtpResponse> verifyOtp(String otp) {
    return service.verifyOtp(otp);
  }
}
