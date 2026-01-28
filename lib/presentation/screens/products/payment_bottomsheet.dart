import 'package:flutter/material.dart';
import 'package:smart_finger/core/colors.dart';

class PaymentBottomSheet extends StatelessWidget {
  final double amount;
  final VoidCallback onCash;
  final VoidCallback onRazorPaySuccess;

  const PaymentBottomSheet({
    super.key,
    required this.amount,
    required this.onCash,
    required this.onRazorPaySuccess,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity, // ✅ FULL WIDTH
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Text(
              "Pay ₹$amount",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCash,
                child: const Text(
                  "Cash Payment",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: onRazorPaySuccess,
                child: const Text(
                  "Razorpay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
