import 'package:smart_finger/data/models/invoice_history_model.dart';

import '../models/invoice_request_model.dart';
import '../models/invoice_response_model.dart';
import '../services/invoice_service.dart';

class InvoiceRepository {
  final InvoiceService service;

  InvoiceRepository(this.service);

  Future<InvoiceResponse> createInvoice(
    InvoiceRequest request,
  ) {
    return service.createInvoice(request);
  }

   Future<List<InvoiceHistoryModel>> getInvoices() async {
    final data = await service.fetchInvoices();

    if (data['status'] == 'success') {
      return (data['invoices'] as List)
          .map((e) => InvoiceHistoryModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load invoices");
    }
  }
}
