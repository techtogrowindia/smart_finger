import 'package:flutter/material.dart';
import 'package:smart_finger/presentation/screens/home/home_screen.dart';

class TestNotificationPage extends StatelessWidget {
  const TestNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Test Page"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Go back to Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          },
          child: const Text("Go to Home"),
        ),
      ),
    );
  }
}
