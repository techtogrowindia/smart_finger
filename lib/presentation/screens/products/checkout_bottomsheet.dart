import 'package:flutter/material.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/data/models/selected_products.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final Complaint complaint;
  final List<SelectedProduct> items;
  final Function(double payableAmount, ) onProceed;

  const CheckoutBottomSheet({
    super.key,
    required this.complaint,
    required this.items,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold(0.0, (sum, p) => sum + p.total);
    final inWarranty = complaint.warrantyLabel == "In Warranty";
    final payable = inWarranty ? 0.0 : total;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Invoice",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            ...items.map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${e.name} x${e.quantity}"),
                  Text("₹${e.total.toStringAsFixed(2)}"),
                ],
              ),
            ),

            const Divider(),
            _row("Total", total),
            _row("Warranty Discount(100%)", inWarranty ? total : 0),
            _row("Payable", payable, bold: true),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () => onProceed(payable),
              child: Text(
                payable == 0 ? "Complete" : "Pay Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
