class LoginResponse {
  int? statusCode;
  String? status;
  String? message;
  String? token;
  int? minutes;

  LoginResponse({
    this.statusCode,
    this.status,
    this.message,
    this.token,
    this.minutes
  });

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["status_code"];
    status = json["status"];
    message = json["message"];
    token = json["token"];
    minutes = json["tracker_duration"];
  }
}
