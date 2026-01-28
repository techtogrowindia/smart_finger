class InvoiceRequest {
  final int complaintId;
  final int technicianId;
  final List<InvoiceProduct> products;
  final double subtotal;
  final double discount;
  final double total;
  final String description;
  final String paymentMethod;
  final String paymentReferenceId;

  InvoiceRequest({
    required this.complaintId,
    required this.technicianId,
    required this.products,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.description,
    required this.paymentMethod,
    required this.paymentReferenceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "complaint_id": complaintId,
      "technician_id": technicianId,
      "products": products.map((e) => e.toJson()).toList(),
      "subtotal": subtotal,
      "discount": discount,
      "total": total,
      "description": description,
      "payment_method": paymentMethod,
      "payment_reference_id": paymentReferenceId,
    };
  }
}

class InvoiceProduct {
  final int productId;
  final int quantity;
  final double price;

  InvoiceProduct({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "quantity": quantity,
      "price": price,
    };
  }
}
