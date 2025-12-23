// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  late LatLng complaintLocation;
  LatLng? technicianLocation;

  BitmapDescriptor? toolMarkerIcon;
  double distanceInKm = 0;

  bool _mapReady = false; // 🔥 KEY FIX

  @override
  void initState() {
    super.initState();
    complaintLocation = LatLng(widget.latitude, widget.longitude);
    _prepareMap();
  }

  // ================= PRELOAD EVERYTHING =================
  Future<void> _prepareMap() async {
    toolMarkerIcon = await _resizeMarker(
      'assets/icons/tools_marker.png',
      90,
    );

    await _getTechnicianLocation();
    _addMarkers();

    setState(() => _mapReady = true); // ✅ NOW BUILD MAP
  }

  // ================= RESIZE MARKER =================
  Future<BitmapDescriptor> _resizeMarker(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final bytes =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<void> _getTechnicianLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    technicianLocation = LatLng(pos.latitude, pos.longitude);

    distanceInKm = _calculateDistance(
      technicianLocation!.latitude,
      technicianLocation!.longitude,
      complaintLocation.latitude,
      complaintLocation.longitude,
    );
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  // ================= MARKERS =================
  void _addMarkers() {
    _markers.clear();

    if (technicianLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("tech"),
          position: technicianLocation!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "You"),
        ),
      );
    }

    _markers.add(
      Marker(
        markerId: const MarkerId("complaint"),
        position: complaintLocation,
        icon: toolMarkerIcon!,
        anchor: const Offset(0.5, 1.0), // 🎯 exact lat/long
        infoWindow: const InfoWindow(title: "Complaint Location"),
      ),
    );
  }

  // ================= NAVIGATION =================
  Future<void> _navigateToGoogleMaps() async {
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${complaintLocation.latitude},${complaintLocation.longitude}",
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Location")),

      body: !_mapReady
          ? const Center(
              child: CircularProgressIndicator(), // ✅ NO DELAY
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: complaintLocation,
                zoom: 16,
              ),
              markers: _markers,
              myLocationEnabled: true,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),

      bottomNavigationBar: technicianLocation == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.route, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        "Distance: ${distanceInKm.toStringAsFixed(2)} km",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _navigateToGoogleMaps,
                        icon: const Icon(Icons.directions),
                        label: const Text("Navigate"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
