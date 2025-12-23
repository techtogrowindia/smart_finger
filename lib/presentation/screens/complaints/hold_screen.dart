// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_state.dart';
import 'complaints_detail_screen.dart';

class HoldScreen extends StatefulWidget {
  
  final bool isOnDuty;
  const HoldScreen({super.key, required this.isOnDuty});

  @override
  State<HoldScreen> createState() => _HoldScreenState();
}

class _HoldScreenState extends State<HoldScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            
            return false;
          },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hold", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          elevation: 5,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          builder: (context, state) {
            if (state is ComplaintsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ComplaintsLoaded) {
              final hold = state.complaints
                  .where((c) => c.status.toUpperCase() == 'HOLD')
                  .toList();
              if (hold.isEmpty) return const Center(child: Text("No hold tasks"));
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: hold.length,
                itemBuilder: (context, index) =>
                    _buildComplaintItem(hold[index], context),
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

  Widget _buildComplaintItem(Complaint c, BuildContext context) {
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
            builder: (_) => ComplaintDetailsScreen(complaint: c, isOnDuty: widget.isOnDuty,),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    // Since this is HoldScreen, all statuses are HOLD
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
