import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/models/bank_update_request.dart';
import 'package:smart_finger/data/repositories/bank_repository.dart';

import 'bank_state.dart';

class BankCubit extends Cubit<BankState> {
  final BankRepository repository;

  BankCubit(this.repository) : super(BankInitial());

  Future<void> updateBankDetails(BankUpdateRequest request) async {
    emit(BankLoading());
    try {
      await repository.updateBank(request);
      emit(BankSuccess());
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }

   void reset() {
    emit(BankInitial());
  }
}
