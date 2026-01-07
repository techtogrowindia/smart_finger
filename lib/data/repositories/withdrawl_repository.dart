

import 'package:smart_finger/data/models/withdrawl_response.dart';
import 'package:smart_finger/data/services/withdrawl_service.dart';

class WithdrawalRepository {
  final WithdrawalService service;

  WithdrawalRepository( {required this.service});

  Future<WithdrawalResponse> withdrawAmount(int amount) {
    return service.submitWithdrawal(amount);
  }
}
