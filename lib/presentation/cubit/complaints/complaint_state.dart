import 'package:smart_finger/data/models/complaints_response.dart';

abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

// 🔄 When update API is calling
class ComplaintsUpdating extends ComplaintsState {}

// ✅ After update success
class ComplaintsUpdateSuccess extends ComplaintsState {
  final String message;
  ComplaintsUpdateSuccess(this.message);
}

class ComplaintsLoaded extends ComplaintsState {
  final List<Complaint> complaints;
  ComplaintsLoaded(this.complaints);
}

class ComplaintsError extends ComplaintsState {
  final String message;
  ComplaintsError(this.message);
}
