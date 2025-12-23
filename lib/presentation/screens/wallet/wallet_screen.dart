// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smart_finger/core/colors.dart';

class WalletScreen extends StatelessWidget {
  final String balance;

  const WalletScreen({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          title: const Text("My Wallet", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Available Balance",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹$balance",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
