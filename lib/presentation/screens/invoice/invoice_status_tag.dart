import 'package:flutter/material.dart';

class InvoiceStatusTag extends StatelessWidget {
  final String status;

  const InvoiceStatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status.toLowerCase() == "paid";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPaid ? Colors.green : Colors.red),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11, // 👈 tag size
          fontWeight: FontWeight.w600,
          color: isPaid ? Colors.green.shade800 : Colors.red.shade800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
