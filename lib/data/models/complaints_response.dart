class Complaint {
  final int id;
  final int? userId;
  final int? technicianId;

  final String address;
  final String city;
  final String pincode;

  final String latitude;
  final String longitude;

  final String warrantyNumber;
  final String alternatePhoneNumber;

  final String comments;
  final String privateNotes;

  final String status;

  final String customerName;
  final String customerNumber;

  final String createdAt;
  final String updatedAt;

  Complaint({
    required this.id,
    this.userId,
    this.technicianId,
    required this.address,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.warrantyNumber,
    required this.alternatePhoneNumber,
    required this.comments,
    required this.privateNotes,
    required this.status,
    required this.customerName,
    required this.customerNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      technicianId: json['technician_id'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      warrantyNumber: json['warranty_number'] ?? '',
      alternatePhoneNumber: json['alternate_phone_number'] ?? '',
      comments: json['comments'] ?? '',
      privateNotes: json['private_notes'] ?? '',
      status: json['status'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerNumber: json['customer_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
