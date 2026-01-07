// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/data/models/profile_response.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/services/logout_service.dart';
import 'package:smart_finger/presentation/cubit/profile/bank_cubit.dart';
import 'package:smart_finger/presentation/screens/common/exit_dialog.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';
import 'package:smart_finger/presentation/screens/login/login_screen.dart';
import 'package:smart_finger/presentation/screens/profile/bank_details_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileData profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BankDetails? _localBank; // <- local bank details for immediate updates

  @override
  void initState() {
    super.initState();
    _localBank = widget.profile.bankDetails; // initial data
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          elevation: 5,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final shouldExit = await ExitConfirmation.show(
                  context,
                  message: 'Do you want to logout?',
                );

                if (shouldExit) {
                  final result = await LogoutService().logout();
                  if (result == "SUCCESS") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  } else if (result == "NO_INTERNET") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NoInternetScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Logout failed. Please try again."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              /// PROFILE HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: widget.profile.profileImage.isNotEmpty
                          ? NetworkImage(widget.profile.profileImage)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: widget.profile.profileImage.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.profile.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.profile.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// BASIC INFO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoCard(
                    icon: Icons.phone,
                    label: "Mobile",
                    value: widget.profile.mobile,
                    width: (width - 40) / 2,
                  ),
                  _infoCard(
                    icon: Icons.location_city,
                    label: "District",
                    value: widget.profile.district.isEmpty
                        ? "-"
                        : widget.profile.district,
                    width: (width - 40) / 2,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoCard(
                    icon: Icons.pin,
                    label: "Pincode",
                    value: widget.profile.pincode.isEmpty
                        ? "-"
                        : widget.profile.pincode,
                    width: (width - 40) / 2,
                  ),
                  _infoCard(
                    icon: Icons.person,
                    label: "User ID",
                    value: widget.profile.userId.toString(),
                    width: (width - 40) / 2,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              _bankDetailsCard(_localBank), // use local bank
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _bankDetailsCard(BankDetails? bank) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bank Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary),
                onPressed: () async {
                  final updatedBank = await showDialog<BankDetails>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => BankDetailsDialog(bank: bank),
                  );

                  context.read<BankCubit>().reset();

                  if (updatedBank != null) {
                    setState(() {
                      _localBank = updatedBank; // update local bank
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (bank == null)
            const Text(
              "Bank details not added",
              style: TextStyle(color: Colors.grey),
            )
          else ...[
            _bankRow("Bank Name", bank.bankName),
            _bankRow("Account Name", bank.accountName),
            _bankRow("Account No", bank.accountNo),
            _bankRow("IFSC", bank.ifsc),
            _bankRow("Branch", bank.branchName),
            _bankRow("UPI ID", bank.upiId),
            _bankRow("GPay No", bank.gpayNumber),
          ],
        ],
      ),
    );
  }

  Widget _bankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
