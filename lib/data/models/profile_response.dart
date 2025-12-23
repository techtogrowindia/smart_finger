class ProfileResponse {
  final int statusCode;
  final String status;
  final String message;
  final ProfileData data;

  const ProfileResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      statusCode: json["status_code"] ?? 0,
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: ProfileData.fromJson(json["data"] ?? {}),
    );
  }
}

class ProfileData {
  final int userId;
  final String mobile;
  final String duty;
  final String name;
  final String email;
  final String district;
  final String pincode;
  final String wallet;
  final String profileImage;

  const ProfileData({
    required this.userId,
    required this.mobile,
    required this.duty,
    required this.name,
    required this.email,
    required this.district,
    required this.pincode,
    required this.wallet,
    required this.profileImage,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json["user_id"] ?? 0,
      mobile: json["mobile"] ?? "",
      duty: json["duty"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      district: json["district"] ?? "",
      pincode: json["pincode"] ?? "",
      wallet: json["wallet"] ?? "0",
      profileImage: json["profile_image"] ?? "",
    );
  }
}
