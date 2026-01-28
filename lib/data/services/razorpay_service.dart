import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;

  final Function(String paymentId) onSuccess;
  final VoidCallback onFailure;

  String? _razorpayKey;

  RazorpayService({required this.onSuccess, required this.onFailure}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }

  Future<void> _fetchRazorpayKey() async {
    if (_razorpayKey != null) return;

    final response = await http.get(
      Uri.parse('https://sfadmin.in/app/technician/ledger/rzp.php'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        _razorpayKey = data['razorpay_key'];
      } else {
        throw Exception('Failed to load Razorpay key');
      }
    } else {
      throw Exception('API error');
    }
  }

  void openCheckout({
    required int amount,
    required String description,
    required String contact,
    required String email,
    required String orderId,
  }) async {
    await _fetchRazorpayKey();
    var options = {
      'key': _razorpayKey,
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'order_id': orderId,
      'name': 'SmartFinger',
      'description': description,
      'prefill': {'contact': contact, 'email': email},
    };

    _razorpay.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    onSuccess(response.paymentId!);
  }

  void _handleError(PaymentFailureResponse response) {
    onFailure();
  }

  void dispose() {
    _razorpay.clear();
  }
}
