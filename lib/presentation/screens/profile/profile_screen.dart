// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:smart_finger/data/models/profile_response.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/services/logout_service.dart';
import 'package:smart_finger/presentation/screens/common/exit_dialog.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';
import 'package:smart_finger/presentation/screens/login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileData profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          elevation: 5,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
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
                      backgroundImage: profile.profileImage.isNotEmpty
                          ? NetworkImage(profile.profileImage)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: profile.profileImage.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoCard(
                    icon: Icons.phone,
                    label: "Mobile",
                    value: profile.mobile,
                    width: (width - 40) / 2,
                  ),
                  _infoCard(
                    icon: Icons.location_city,
                    label: "District",
                    value: profile.district,
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
                    value: profile.pincode,
                    width: (width - 40) / 2,
                  ),
                  _infoCard(
                    icon: Icons.person,
                    label: "User ID",
                    value: profile.userId.toString(),
                    width: (width - 40) / 2,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _actionButton(
                context,
                icon: Icons.edit,
                label: "Edit Profile",
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _actionButton(
                context,
                icon: Icons.logout,
                label: "Logout",
                onTap: () async {
                  final shouldExit = await ExitConfirmation.show(
                    context,
                    message:
                        'Do you want to leave Complaint Details and go to Home?',
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

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
