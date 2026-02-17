import 'package:flutter/material.dart';
import 'package:smart_finger/core/shared_prefs_helper.dart';

class LocationUsageDialog {
  static Future<bool> show(BuildContext context) async {
    bool isChecked = false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text("🔔 Location Usage Disclosure"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SmartFingers Technician App\n\n"
                          "To provide core service functionality, SmartFingers Technician App requires access to your location data, including background location (even when the app is closed or not in use).\n\n"
                          "We use location access to:\n\n"
                          "• Navigate technicians to customer service locations\n"
                          "• Track total kilometers traveled during active jobs\n"
                          "• Calculate wallet balance and technician payments accurately\n"
                          "• Ensure proper job tracking and service accountability\n\n"
                          "Location data is collected only during active service jobs and is not used for advertising or shared with third parties.\n\n"
                          "You can manage or revoke this permission anytime from your device settings.",
                        ),
                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (v) {
                                setState(() => isChecked = v ?? false);
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "I understand and agree to the collection and use of my location data as described above.",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Exit App",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isChecked
                          ? () async {
                              await SharedPrefsHelper.saveLocationConsent(true);
                              Navigator.pop(context, true);
                            }
                          : null,
                      child: const Text("Agree & Continue"),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
  }
}
