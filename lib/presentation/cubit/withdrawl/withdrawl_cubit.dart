import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/repositories/withdrawl_repository.dart';
import 'package:smart_finger/presentation/cubit/withdrawl/withdrawl_state.dart';

class WithdrawalCubit extends Cubit<WithdrawalState> {
  final WithdrawalRepository repository;
  WithdrawalCubit({required this.repository}) : super(WithdrawalInitial());

  void submitWithdrawal(int amount) async {
    try {
      emit(WithdrawalLoading());
      final response = await repository.withdrawAmount(amount);
      emit(WithdrawalSuccess(response));
    } catch (e) {
      emit(WithdrawalError(e.toString()));
    }
  }
}
