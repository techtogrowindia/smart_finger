import 'package:smart_finger/data/models/invoice_history_model.dart';
import 'package:smart_finger/data/models/invoice_response_model.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {
  final InvoiceResponse response;
  InvoiceSuccess(this.response);
}


class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);
}

class InvoiceHistoryInitial extends InvoiceState {}

class InvoiceHistoryLoading extends InvoiceState {}



class InvoiceHistoryLoaded extends InvoiceState {
  final List<InvoiceHistoryModel> invoices;
  InvoiceHistoryLoaded(this.invoices);
}
class InvoiceHistoryError extends InvoiceState {
  final String message;
  InvoiceHistoryError(this.message);
}
