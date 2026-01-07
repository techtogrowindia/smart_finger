import 'package:smart_finger/data/models/withdrawl_response.dart';

abstract class WithdrawalState {}

class WithdrawalInitial extends WithdrawalState {}
class WithdrawalLoading extends WithdrawalState {}
class WithdrawalSuccess extends WithdrawalState {
  final WithdrawalResponse response;
  WithdrawalSuccess(this.response);
}
class WithdrawalError extends WithdrawalState {
  final String message;
  WithdrawalError(this.message);
}
