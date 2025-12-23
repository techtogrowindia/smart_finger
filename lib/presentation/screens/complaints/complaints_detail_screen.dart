// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/complaints_response.dart';

import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_state.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_cubit.dart';
import 'package:smart_finger/presentation/cubit/otp/otp_state.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_cubit.dart';
import 'package:smart_finger/presentation/screens/common/google_map_screen.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';
import 'package:smart_finger/presentation/screens/common/otp_bottom_sheet.dart';
import 'package:smart_finger/presentation/screens/home/home_screen.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Complaint complaint;
  final bool isOnDuty;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaint,
    required this.isOnDuty,
  });

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  late String selectedStatus;
  late List<String> statusList;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint.status.toUpperCase();

    statusList = _getStatusList(widget.complaint.status.toUpperCase());
  }

  List<String> _getStatusList(String currentStatus) {
    switch (currentStatus.toUpperCase()) {
      case 'START':
        return ['START', 'REACHED', 'HOLD', 'COMPLETED'];

      case 'REACHED':
        return ['REACHED', 'HOLD', 'COMPLETED'];

      case 'PROGRESSING':
        return ['PROGRESSING', 'START', 'REACHED', 'HOLD', 'COMPLETED'];

      case 'HOLD':
        return ['HOLD', 'START'];

      case 'COMPLETED':
        return ['COMPLETED'];

      default:
        return [currentStatus.toUpperCase()];
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.complaint;

    return MultiBlocListener(
      listeners: [
        BlocListener<OtpCubit, OtpState>(
          listener: (context, otpState) async {
            if (otpState is OtpLoading) {
              _showLoader(context);
            }

            if (otpState is OtpSent) {
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => OtpBottomSheet(
                  onVerified: () {
                    context.read<ComplaintsCubit>().complainClose(
                      complaintId: widget.complaint.id,
                      status: "completed",
                    );
                  },
                ),
              );
            }

            if (otpState is OtpError) {
              Navigator.pop(context);

              if (otpState.message == "NO_INTERNET") {
                final restored = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const NoInternetScreen()),
                );

                if (restored == true) {
                  context.read<OtpCubit>().reset();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(otpState.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
        ),
      ],
      child: BlocConsumer<ComplaintsCubit, ComplaintsState>(
        listener: (context, state) async {
          if (state is ComplaintsUpdating) {
            _showLoader(context);
          }

          if (state is ComplaintsUpdateSuccess) {
            Navigator.pop(context);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
          if (state is ComplaintsError) {
            Navigator.pop(context);

            if (state.message == "NO_INTERNET") {
              final restored = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const NoInternetScreen()),
              );

              if (restored == true) {
                context.read<ComplaintsCubit>().reset();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Complaint Details",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _headerCard(c),
                    const SizedBox(height: 16),
                    _infoCard(
                      title: "Address",
                      icon: Icons.location_on,
                      children: [
                        _infoRow("Address", c.address),
                        _infoRow("City", c.city),
                        _infoRow("Pincode", c.pincode),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _infoCard(
                      title: "Customer",
                      icon: Icons.person,
                      children: [
                        _infoRow("Name", c.customerName),
                        _infoRow("Phone", c.customerNumber),
                        _infoRow("Alternate", c.alternatePhoneNumber),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _infoCard(
                      title: "Complaint Info",
                      icon: Icons.build,
                      children: [
                        _infoRow("Warranty No", c.warrantyNumber),
                        _infoRow("Comments", c.comments),
                        _infoRow("Private Notes", c.privateNotes),
                        _infoRow("Created At", c.createdAt),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerCard(Complaint c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xffa55bff)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Complaint #${c.id}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(c.comments, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: statusList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: statusList.length == 1
                      ? null
                      : (val) => setState(() => selectedStatus = val!),
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed:
                      statusList.length == 1 ||
                          selectedStatus == c.status.toUpperCase()
                      ? null
                      : () async {
                          if (!widget.isOnDuty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please turn ON duty to update complaint",
                                ),
                              ),
                            );
                            return;
                          }

                          if (selectedStatus == "REACHED") {
                            context.read<TrackingCubit>().onReached(
                              complaintLat: double.parse(c.latitude),
                              complaintLng: double.parse(c.longitude),
                            );
                          }

                          if (selectedStatus == "COMPLETED") {
                            context.read<OtpCubit>().sendOtp(c.customerNumber);
                          } else {
                            context
                                .read<ComplaintsCubit>()
                                .updateComplaintStatus(
                                  complaintId: c.id,
                                  status: selectedStatus.toLowerCase(),
                                );
                          }
                        },

                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,

    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                title == 'Address'
                    ? IconButton(
                        icon: const Icon(
                          Icons.directions,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapScreen(
                                latitude: double.parse(
                                  widget.complaint.latitude,
                                ),
                                longitude: double.parse(
                                  widget.complaint.longitude,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Text(''),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(flex: 5, child: Text(value.isEmpty ? "-" : value)),
        ],
      ),
    );
  }

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
