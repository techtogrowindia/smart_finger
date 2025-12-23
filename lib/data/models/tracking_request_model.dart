class TrackingRequestModel {
  final int userId;
  final double latitude;
  final double longitude;
  final double km;
  final int duty;

  TrackingRequestModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.km,
    required this.duty,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "latitude": latitude.toString(),   // backend wants string
      "longitude": longitude.toString(), // backend wants string
      "km": km,
      "duty": duty,
    };
  }
}
