// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_state.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_cubit.dart';
import 'complaints_detail_screen.dart';

class CompletedScreen extends StatefulWidget {
  final bool isOnDuty;
  final int technicianId;
  const CompletedScreen({
    super.key,
    required this.isOnDuty,
    required this.technicianId,
  });

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Completed", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          builder: (context, state) {
            if (state is ComplaintsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ComplaintsLoaded) {
              final completed = state.complaints
                  .where((c) => c.status.toUpperCase() == 'COMPLETED')
                  .toList();
              if (completed.isEmpty) {
                return const Center(child: Text("No completed tasks"));
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: completed.length,
                itemBuilder: (context, index) => _buildComplaintItem(
                  completed[index],
                  context,
                  widget.technicianId,
                ),
              );
            }
            if (state is ComplaintsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildComplaintItem(
    Complaint c,
    BuildContext context,
    int technicianId,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            c.id.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          c.comments,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${c.createdAt}"),
            const SizedBox(height: 6),
            _buildStatusTag(c.status),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ComplaintDetailsScreen(
              complaint: c,
              isOnDuty: context.read<TrackingCubit>().isOnDuty,

              technicianId: technicianId,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
