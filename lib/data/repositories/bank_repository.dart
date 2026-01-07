import 'package:smart_finger/data/models/bank_update_request.dart';
import 'package:smart_finger/data/services/bank_service.dart';

class BankRepository {
  final BankService service;

  BankRepository(this.service);

  Future<bool> updateBank(BankUpdateRequest request) {
    return service.updateBankDetails(request);
  }
}
