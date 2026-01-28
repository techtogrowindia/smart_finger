class InvoiceHistoryModel {
  final int id;
  final int complaintId;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod;
  final String paymentStatus;
  final String paymentReferenceId;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final String description;
  final String createdAt;
  final String? url;

  InvoiceHistoryModel({
    required this.id,
    required this.complaintId,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentReferenceId,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.description,
    required this.createdAt,
    this.url,
  });

  factory InvoiceHistoryModel.fromJson(Map<String, dynamic> json) {
    return InvoiceHistoryModel(
      id: json['id'],
      complaintId: json['complaint_id'],
      subtotal: double.parse(json['subtotal']),
      discount: double.parse(json['discount']),
      total: double.parse(json['total']),
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      paymentReferenceId: json['payment_reference_id'] ?? '',
      razorpayOrderId: json['razorpay_order_id'],
      razorpayPaymentId: json['razorpay_payment_id'],
      description: json['description'] ?? '',
      createdAt: json['created_at'],
      url: json['url'] ?? '',
    );
  }

  bool get isPaid => paymentStatus.toLowerCase() == "paid";
}
