class LoginResponse {
  int? statusCode;
  String? status;
  String? message;
  String? token;

  LoginResponse({
    this.statusCode,
    this.status,
    this.message,
    this.token,
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["status_code"];
    status = json["status"];
    message = json["message"];
    token = json["token"]; // ✅ THIS WAS MISSING / WRONG
  }
}
