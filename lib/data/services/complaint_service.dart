import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/models/complaints_response.dart';

class ComplaintsService {
  static const String _fetchUrl =
      "https://sfadmin.in/app/technician/complaints/complaints.php";

  static const String _updateUrl =
      "https://sfadmin.in/app/technician/complaints/complaint_update.php";

  static const String _closeUrl =
      "https://sfadmin.in/app/technician/complaints/complaint_close.php";



  Future<List<Complaint>> fetchComplaints() async {
    final token = await SharedPrefsHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await http.get(
      Uri.parse(_fetchUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);

    if (body['status'] == 'success') {
      final List list = body['data']['complaints'];
      return list.map((e) => Complaint.fromJson(e)).toList();
    } else {
      throw Exception(body['message'] ?? "Failed to load complaints");
    }
  }


  Future<bool> updateComplaintStatus({
    required int complaintId,
    required String status,
  }) async {
    final token = await SharedPrefsHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await http.post(
      Uri.parse(_updateUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "complaint_id": complaintId,
        "status": status, 
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);

    if (body['status'] == 'success') {
      return true;
    } else {
      throw Exception(body['message'] ?? "Status update failed");
    }
  }

  Future<bool> complaintClose({
    required int complaintId,
    required String status,
  }) async {
    final token = await SharedPrefsHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    final response = await http.post(
      Uri.parse(_closeUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "complaint_id": complaintId,
        "status": status, 
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Server error: ${response.statusCode}");
    }

    final body = jsonDecode(response.body);

    if (body['status'] == 'success') {
      return true;
    } else {
      throw Exception(body['message'] ?? "Status update failed");
    }
  }

}
