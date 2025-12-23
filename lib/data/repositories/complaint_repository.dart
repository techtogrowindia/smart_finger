import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/data/services/complaint_service.dart';

class ComplaintsRepository {
  final ComplaintsService service;

  ComplaintsRepository(this.service);

  Future<List<Complaint>> getComplaints() {
    return service.fetchComplaints();
  }
  Future<bool> updateComplaintStatus({
    required int complaintId,
    required String status,
  }) {
    return service.updateComplaintStatus(
      complaintId: complaintId,
      status: status,
    );
  }

   Future<bool> complaintClose({
    required int complaintId,
    required String status,
  }) {
    return service.complaintClose(
      complaintId: complaintId,
      status: status,
    );
  }
}
