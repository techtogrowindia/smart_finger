import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/send_otp_response.dart';
import '../models/verify_otp_response.dart';

class OtpService {
  static const sendOtpUrl = "https://sfadmin.in/app/technician/send_otp.php";

  static const verifyOtpUrl =
      "https://sfadmin.in/app/technician/verify_otp.php";

  Future<SendOtpResponse> sendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse(sendOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"mobile": mobile}),
    );

    if (response.statusCode == 200) {
      return SendOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Send OTP failed");
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String otp) async {
    final response = await http.post(
      Uri.parse(verifyOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"otp": otp}),
    );

    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Verify OTP failed");
    }
  }
}
