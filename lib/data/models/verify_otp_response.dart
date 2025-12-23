class VerifyOtpResponse {
  final int status;
  final String message;

  VerifyOtpResponse({
    required this.status,
    required this.message,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
