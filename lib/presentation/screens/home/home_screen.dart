// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:smart_finger/core/colors.dart';
import 'package:smart_finger/core/firebase/fcm_helper.dart';

import 'package:smart_finger/data/models/profile_response.dart';
import 'package:smart_finger/data/models/complaints_response.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_cubit.dart';
import 'package:smart_finger/presentation/cubit/complaints/complaint_state.dart';
import 'package:smart_finger/presentation/cubit/profile/profile_cubit.dart';
import 'package:smart_finger/presentation/cubit/profile/profile_state.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_cubit.dart';
import 'package:smart_finger/presentation/cubit/tracking/tracking_state.dart';
import 'package:smart_finger/presentation/screens/common/exit_dialog.dart';
import 'package:smart_finger/presentation/screens/common/no_internet_screen.dart';
import 'package:smart_finger/presentation/screens/complaints/complaints_detail_screen.dart';
import 'package:smart_finger/presentation/screens/complaints/completed_screen.dart';
import 'package:smart_finger/presentation/screens/complaints/hold_screen.dart';
import 'package:smart_finger/presentation/screens/notifications/notifications_screen.dart';
import 'package:smart_finger/presentation/screens/wallet/wallet_screen.dart';
import 'package:smart_finger/presentation/screens/profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  final String? highlightComplaintId;
  const HomePage({super.key, this.highlightComplaintId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String currentLocation = "Fetching location...";
  bool isOnDuty = false;
  ProfileData? profileData;
  String walletAmount = "0";
  int completedCount = 0;
  int holdCount = 0;
  int? userId;
  double? currentLat;
  double? currentLng;
  bool isLocationReady = false;
  DateTime? selectedDate;
  bool _askedNotification = false;
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().loadProfile();
    context.read<ComplaintsCubit>().loadComplaints();
    _loadCurrentLocation();
    FcmHelper.handleNotificationPermission();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => currentLocation = "Location service disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => currentLocation = "Location permission denied");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLng = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocation =
            "${place.subLocality ?? place.locality}, ${place.locality}";
      }

      setState(() {
        isLocationReady = true;
      });

      if (!_askedNotification) {
        _askedNotification = true;
        await Future.delayed(const Duration(seconds: 2));
        await FcmHelper.handleNotificationPermission();
      }
    } catch (e) {
      setState(() => currentLocation = "Unable to fetch location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ExitConfirmation.show(
          context,
          message: 'Do you want to exit the app?',
          title: 'Exit App',
          closeApp: true,
        );
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) async {
            if (state is ProfileSuccess) {
              profileData = state.response.data;
              walletAmount = profileData!.wallet;
              userId = profileData!.userId;

              setState(() {});

              FcmHelper(technicianId: userId!).initFCM();
            }
          },
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeTab(),
              CompletedScreen(isOnDuty: context.read<TrackingCubit>().isOnDuty),
              HoldScreen(isOnDuty: context.read<TrackingCubit>().isOnDuty),
              WalletScreen(initialBalance: walletAmount),
              profileData == null
                  ? const Center(child: CircularProgressIndicator())
                  : ProfileScreen(profile: profileData!),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.home, color: Colors.white, size: 28),
          onPressed: () => setState(() => _currentIndex = 0),
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        _buildStatsRow(),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Complaints",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Refresh button
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.primary),
                    tooltip: "Refresh complaints for today",
                    onPressed: () {
                      context.read<ComplaintsCubit>().loadComplaints();
                    },
                  ),

                  if (selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.primary),
                      tooltip: "Clear filter",
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                    ),
                    tooltip: "Filter by date",
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        Expanded(
          child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
            builder: (context, state) {
              if (state is ComplaintsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ComplaintsLoaded) {
                completedCount = state.complaints
                    .where((c) => c.status.toUpperCase() == 'COMPLETED')
                    .length;

                holdCount = state.complaints
                    .where((c) => c.status.toUpperCase() == 'HOLD')
                    .length;

                List<Complaint> active = state.complaints.where((c) {
                  final statusOk =
                      c.status.toUpperCase() != 'HOLD' &&
                      c.status.toUpperCase() != 'COMPLETED';

                  if (selectedDate == null) return statusOk;

                  final created = DateTime.parse(c.createdAt);
                  return statusOk &&
                      created.year == selectedDate!.year &&
                      created.month == selectedDate!.month &&
                      created.day == selectedDate!.day;
                }).toList();
                active.sort(
                  (a, b) => DateTime.parse(
                    b.createdAt,
                  ).compareTo(DateTime.parse(a.createdAt)),
                );

                if (widget.highlightComplaintId != null) {
                  final index = active.indexWhere(
                    (c) => c.id.toString() == widget.highlightComplaintId,
                  );

                  if (index != -1) {
                    final item = active.removeAt(index);
                    active.insert(0, item);
                  }
                }

                if (active.isEmpty) {
                  return const Center(child: Text("No complaints found"));
                }

                return _buildComplaintList(active);
              }

              if (state is ComplaintsError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xffa55bff)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "SmartFingers",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NotificationScreen()),
                      );
                    },
                    icon: Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("ON DUTY", style: TextStyle(color: Colors.white)),
                  BlocConsumer<TrackingCubit, TrackingState>(
                    listener: (context, state) async {
                      if (state is TrackingError) {
                        if (state.message == "NO_INTERNET") {
                          final restored = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NoInternetScreen(),
                            ),
                          );

                          if (restored == true) {
                            context.read<TrackingCubit>().reset();
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
                      final trackingCubit = context.read<TrackingCubit>();

                      return Switch(
                        value: trackingCubit.isOnDuty,
                        onChanged:
                            (!isLocationReady || state is TrackingInProgress)
                            ? null
                            : (val) async {
                                final service = FlutterBackgroundService();

                                if (val) {
                                  // Start service only if not running
                                  if (!(await service.isRunning())) {
                                    await service.startService();
                                  }

                                  trackingCubit.onDuty(
                                    userId: userId!,
                                    lat: currentLat!,
                                    lng: currentLng!,
                                  );
                                } else {
                                  // Stop background service
                                  service.invoke("stopService");

                                  trackingCubit.offDuty(
                                    userId: userId!,
                                    lat: currentLat!,
                                    lng: currentLng!,
                                  );
                                }
                              },
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: Colors.white70,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  currentLocation,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statCard(Icons.check_circle, "Completed", completedCount.toString()),
          _statCard(Icons.pause_circle_filled, "Hold", holdCount.toString()),
          _statCard(Icons.account_balance_wallet, "Wallet", "₹$walletAmount"),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, String value) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintList(List<Complaint> complaints) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final c = complaints[index];
        final bool isHighlighted =
            widget.highlightComplaintId != null &&
            c.id.toString() == widget.highlightComplaintId;
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: isHighlighted ? 6 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isHighlighted
                ? const BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
          ),
          color: isHighlighted
              ? AppColors.primary.withOpacity(0.08)
              : Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                c.id.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    c.comments,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (isHighlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "NEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusTag(String status) {
    Color bg;
    Color text;

    switch (status.toUpperCase()) {
      case 'START':
        bg = Colors.blue.withOpacity(0.15);
        text = Colors.blue;
        break;
      case 'HOLD':
        bg = Colors.red.withOpacity(0.15);
        text = Colors.red;
        break;
      case 'COMPLETED':
        bg = Colors.green.withOpacity(0.15);
        text = Colors.green;
        break;
      case 'REACHED':
        bg = Colors.deepPurple.withOpacity(0.15);
        text = Colors.deepPurple;
        break;
      default:
        bg = Colors.orange.withOpacity(0.15);
        text = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: AppColors.primary,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.check_circle, "Completed", 1),
          _navItem(Icons.pause_circle, "Hold", 2),
          const SizedBox(width: 40),
          _navItem(Icons.account_balance_wallet, "Wallet", 3),
          _navItem(Icons.person, "Profile", 4),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.white70, size: 22),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
