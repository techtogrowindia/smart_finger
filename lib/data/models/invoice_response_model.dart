class InvoiceResponse {
  final String status;
  final String message;
  final String razorpayOrderId;
  final int invoiceId;
  final int amount;
  final String currency;

  InvoiceResponse({
    required this.status,
    required this.message,
    required this.razorpayOrderId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      status: json["status"] ??"",
      message: json["message"] ?? "",
      razorpayOrderId: json["razorpay_order_id"] ?? "",
      invoiceId: json["invoice_id"] ?? 0,
      amount: json["amount"] ?? 0,
      currency: json["currency"] ?? "",

    );
  }
}
