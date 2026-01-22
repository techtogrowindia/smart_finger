import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/complaint_repository.dart';
import 'complaint_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ComplaintsRepository repository;

  ComplaintsCubit(this.repository) : super(ComplaintsInitial());
  Future<void> loadComplaints() async {
    emit(ComplaintsLoading());

    try {
      final complaints = await repository.getComplaints();
      emit(ComplaintsLoaded(complaints));
    } on SocketException {
      emit( ComplaintsError("NO_INTERNET"));
    } catch (_) {
      emit( ComplaintsError("Something went wrong"));
    }
  }

  Future<void> updateComplaintStatus({
    required int complaintId,
    required String status,
  }) async {
    emit(ComplaintsUpdating());

    try {
      await repository.updateComplaintStatus(
        complaintId: complaintId,
        status: status,
      );

      emit( ComplaintsUpdateSuccess("Status updated successfully"));
    } on SocketException {
      emit( ComplaintsError("NO_INTERNET"));
    } catch (_) {
      emit( ComplaintsError("Something went wrong"));
    }
  }


  Future<void> complainClose({
    required int complaintId,
    required String status,
  }) async {
    emit(ComplaintsUpdating());

    try {
      await repository.complaintClose(
        complaintId: complaintId,
        status: status,
      );

      emit( ComplaintsUpdateSuccess("Status updated successfully"));
    } on SocketException {
      emit( ComplaintsError("NO_INTERNET"));
    } catch (_) {
      emit( ComplaintsError("Something went wrong"));
    }
  }

  

  void reset() {
    emit(ComplaintsInitial());
  }
}
