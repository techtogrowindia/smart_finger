import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  /// REQUIRED: Make foreground service (Android)
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "SmartFingers",
      content: "Updating location in background",
    );
  }

  Timer? timer;

  /// Stop service from UI
  service.on('stopService').listen((event) {
    timer?.cancel();
    service.stopSelf();
    print("Background service stopped");
  });

  /// Run immediately once
  _updateLocation();

  /// Periodic update every 10 minutes
  timer = Timer.periodic(const Duration(minutes: 10), (timer) {
    _updateLocation();
  });
}

/// Separate function (clean & safe)
Future<void> _updateLocation() async {
  try {
    final token = await SharedPrefsHelper.getToken();

    if (token == null || token.isEmpty) {
      print("No auth token found");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = position.latitude;
    final lng = position.longitude;


    final response = await http.post(
      Uri.parse(
        "https://sfadmin.in/app/technician/auth/update-technician-location.php",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "latitude": lat.toString(),
        "longitude": lng.toString(),
      }),
    );

    print("Background API response: ${response.statusCode}");
  } catch (e) {
    print("Background location error: $e");
  }
}
