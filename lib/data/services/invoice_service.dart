import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';
import '../models/invoice_request_model.dart';
import '../models/invoice_response_model.dart';

class InvoiceService {
  Future<InvoiceResponse> createInvoice(InvoiceRequest request) async {
    final token = await SharedPrefsHelper.getToken();
    final url = Uri.parse(
      "https://sfadmin.in/app/technician/ledger/invoice.php",
    );

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );


    if (response.statusCode == 200) {

      return InvoiceResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return InvoiceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> fetchInvoices() async {
    final token = await SharedPrefsHelper.getToken();
    final response = await http.post(
      Uri.parse("https://sfadmin.in/app/technician/ledger/invoices.php"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load invoices');
    }
  }
}
