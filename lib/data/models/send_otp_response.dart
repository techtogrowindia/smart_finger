class SendOtpResponse {
  final int status;
  final String message;
  final OtpData data;

  SendOtpResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      status: json['status'],
      message: json['message'],
      data: OtpData.fromJson(json['data']),
    );
  }
}

class OtpData {
  final String phone;
  final String otp;
  final String messageId;

  OtpData({
    required this.phone,
    required this.otp,
    required this.messageId,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      phone: json['phone'],
      otp: json['otp'].toString(),
      messageId: json['messageId'].toString(),
    );
  }
}
