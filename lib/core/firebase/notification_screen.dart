// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:smart_finger/presentation/screens/home/home_screen.dart';

class NotificationScreen extends StatefulWidget {
  final String title;
  final String message;
  final String complaintId;

  const NotificationScreen({
    super.key,
    required this.title,
    required this.message,
    required this.complaintId,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _dragValue = 0;

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  /// 🔊 Play notification sound in loop
  Future<void> _playSound() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
  }

  /// 🔇 Stop sound
  Future<void> _stopSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }

  @override
  void dispose() {
    _stopSound();
    super.dispose();
  }

  String get todayDate =>
      DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _stopSound();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () async {
                      await _stopSound();
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔔 Icon
                const Icon(
                  Icons.notifications_active,
                  size: 80,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// 📄 Message
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                Text(
                  "Complaint ID: ${widget.complaintId}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                /// 📅 Date
                Text(
                  todayDate,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const Spacer(),

                /// 👉 Swipe to Accept
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Center(
                        child: Text(
                          "Swipe to Accept",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _dragValue += details.delta.dx;
                            if (_dragValue < 0) _dragValue = 0;
                          });
                        },
                        onHorizontalDragEnd: (_) async {
                          if (_dragValue >
                              MediaQuery.of(context).size.width * 0.5) {
                            await _stopSound();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePage(
                                  highlightComplaintId: widget.complaintId,
                                ),
                              ),
                              (route) => false,
                            );
                          } else {
                            setState(() => _dragValue = 0);
                          }
                        },
                        child: Transform.translate(
                          offset: Offset(_dragValue, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
