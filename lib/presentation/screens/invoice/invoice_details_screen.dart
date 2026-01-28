import 'package:flutter/material.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/invoice_history_model.dart';
import 'package:smart_finger/presentation/screens/invoice/invoice_status_tag.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceHistoryModel invoice;

  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            "Invoice #${invoice.id}",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            children: [
              _infoCard(
                title: "Payment Status",
                child: InvoiceStatusTag(status: invoice.paymentStatus),
              ),

              _infoCard(
                title: "Invoice Details",
                child: Column(
                  children: [
                    _row("Complaint ID", invoice.complaintId.toString()),
                    _row("Subtotal", "₹ ${invoice.subtotal}"),
                    _row("Discount", "₹ ${invoice.discount}"),
                    _row("Total", "₹ ${invoice.total}", isBold: true),
                  ],
                ),
              ),

              _infoCard(
                title: "Payment Info",
                child: Column(
                  children: [
                    _row("Method", invoice.paymentMethod),
                    _row(
                      "Reference ID",
                      invoice.paymentReferenceId.isEmpty
                          ? "-"
                          : invoice.paymentReferenceId,
                    ),
                    _row("Razorpay Order ID", invoice.razorpayOrderId ?? "-"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              invoice.url == null || invoice.url!.isEmpty
                  ? Container()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Download Invoice PDF"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          downloadInvoicePdf(invoice.url ?? '');
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadInvoicePdf(String pdfUrl) async {
    final Uri uri = Uri.parse(pdfUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open PDF');
    }
  }
}
