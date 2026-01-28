import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/models/invoice_history_model.dart';
import 'package:smart_finger/data/models/invoice_request_model.dart';
import 'package:smart_finger/data/repositories/invoice_repository.dart';
import 'invoice_state.dart';

enum InvoiceFilter { all, paid, unpaid }

class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepository repository;

  InvoiceCubit(this.repository) : super(InvoiceInitial());
  bool hasLoadedOnce = false;

  Future<void> createInvoice({required InvoiceRequest request}) async {
    try {
      emit(InvoiceLoading());

      final response = await repository.createInvoice(request);
      if (response.status == "success") {
        emit(InvoiceSuccess(response));
      } else if (response.status == "error") {
        emit(InvoiceError(response.message));
      }
    } on SocketException catch (_) {
      emit(InvoiceError("NO_INTERNET"));
    } catch (e) {
      emit(InvoiceError("Failed to generate invoice"));
    }
  }

  List<InvoiceHistoryModel> _allInvoices = [];

  Future<void> loadInvoices() async {
    emit(InvoiceHistoryLoading());

    try {
      final data = await repository.getInvoices();
      _allInvoices = data;
      hasLoadedOnce = true;
      emit(InvoiceHistoryLoaded(_allInvoices));
    } catch (e) {
      emit(InvoiceHistoryError(e.toString()));
    }
  }

  void applyFilter(InvoiceFilter filter) {
    if (_allInvoices.isEmpty) return;

    List<InvoiceHistoryModel> filtered;

    switch (filter) {
      case InvoiceFilter.paid:
        filtered = _allInvoices.where((e) => e.isPaid).toList();
        break;

      case InvoiceFilter.unpaid:
        filtered = _allInvoices.where((e) => !e.isPaid).toList();
        break;

      case InvoiceFilter.all:
        filtered = _allInvoices;
    }

    emit(InvoiceHistoryLoaded(filtered));
  }

  void reset() {
    emit(InvoiceInitial());
  }
}
