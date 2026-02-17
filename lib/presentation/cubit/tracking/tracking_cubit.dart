import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_finger/data/models/tracking_request_model.dart';
import 'package:smart_finger/data/repositories/tracking_repository.dart';
import 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this.repository) : super(TrackingInitial());

  final TrackingRepository repository;

  double? _startLat;
  double? _startLng;

  bool _isOnDuty = false;
  bool _apiBusy = false;

  bool get isOnDuty => _isOnDuty;

  void setInitialDuty({required bool isOnDuty, double? lat, double? lng}) {
    _isOnDuty = isOnDuty;

    if (isOnDuty) {
      _startLat = lat;
      _startLng = lng;
    } else {
      _startLat = null;
      _startLng = null;
    }

    emit(TrackingKmUpdated(0));
  }

  Future<void> onDuty({
    required int userId,
    required double lat,
    required double lng,
  }) async {
    if (_isOnDuty || _apiBusy) return;

    _apiBusy = true;
    emit(TrackingInProgress());

    _isOnDuty = true;

    _startLat = lat;
    _startLng = lng;

    try {
      await repository.sendTracking(
        TrackingRequestModel(
          userId: userId,
          latitude: lat,
          longitude: lng,
          km: 0,
          duty: 1,
        ),
      );

      emit(TrackingKmUpdated(0));
    } on SocketException {
      emit(TrackingError("NO_INTERNET"));
    } catch (e) {
      emit(TrackingError(e.toString()));
    } finally {
      _apiBusy = false;
    }
  }

  Future<void> offDuty({required int userId}) async {
    if (!_isOnDuty || _apiBusy) return;

    _apiBusy = true;
    emit(TrackingInProgress());

    double totalKm = 0;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final lat = position.latitude;
      final lng = position.longitude;

      if (_startLat != null && _startLng != null) {
        final meters = Geolocator.distanceBetween(
          _startLat!,
          _startLng!,
          lat,
          lng,
        );

        totalKm = meters / 1000;
      }

      await repository.sendTracking(
        TrackingRequestModel(
          userId: userId,
          latitude: lat,
          longitude: lng,
          km: double.parse(totalKm.toStringAsFixed(2)),
          duty: 0,
        ),
      );

      emit(TrackingKmUpdated(totalKm));

      _isOnDuty = false;
      _startLat = null;
      _startLng = null;
    } catch (e) {
      emit(TrackingError(e.toString()));
    } finally {
      _apiBusy = false;
    }
  }

  void reset() {
    emit(TrackingInitial());
  }
}
