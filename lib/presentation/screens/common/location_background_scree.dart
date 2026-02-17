import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:smart_finger/core/shared_prefs_helper.dart';

double? _lastLat;
double? _lastLng;
double _totalKm = 0;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "SmartFingers",
      content: "Updating location in background",
    );
  }


  _totalKm = 0;
  _lastLat = null;
  _lastLng = null;


  final minutes = await SharedPrefsHelper.getTrackingInterval();

  print("Tracking interval: $minutes minute(s)");

  Timer? timer;


  service.on('stopService').listen((event) {
    timer?.cancel();

    _totalKm = 0;
    _lastLat = null;
    _lastLng = null;
    service.stopSelf();
    print("Background service stopped");
  });


  _updateLocation();


  timer = Timer.periodic(Duration(minutes: minutes), (timer) {
    _updateLocation();
  });
}

Future<void> _updateLocation() async {
  try {
    final token = await SharedPrefsHelper.getToken();
    if (token == null || token.isEmpty) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = position.latitude;
    final lng = position.longitude;

    if (_lastLat != null && _lastLng != null) {
      final meters = Geolocator.distanceBetween(_lastLat!, _lastLng!, lat, lng);

      final km = meters / 1000;

     
      if (meters > 10) {
        _totalKm += km;
      }
    }


    _lastLat = lat;
    _lastLng = lng;


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
        "km": _totalKm.toStringAsFixed(2),
      }),
    );

    print("KM Sent: $_totalKm");
    print("Status: ${response.statusCode}");
  } catch (e) {
    print("Background location error: $e");
  }
}
