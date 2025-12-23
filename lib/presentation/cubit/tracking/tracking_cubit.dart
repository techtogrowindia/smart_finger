import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_finger/data/models/tracking_request_model.dart';
import 'package:smart_finger/data/repositories/tracking_repository.dart';
import 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this.repository) : super(TrackingInitial());

  final TrackingRepository repository;

  double _totalKm = 0;
  double? _lastLat;
  double? _lastLng;

  bool _isOnDuty = false;
  bool _apiBusy = false;

  bool get isOnDuty => _isOnDuty;

  Future<void> onDuty({
    required int userId,
    required double lat,
    required double lng,
  }) async {
    if (_isOnDuty || _apiBusy) return;

    _apiBusy = true;
    emit(TrackingInProgress());

    _isOnDuty = true;
    _totalKm = 0;
    _lastLat = lat;
    _lastLng = lng;

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

      emit(TrackingKmUpdated(_totalKm));
    } on SocketException {
      emit(TrackingError("NO_INTERNET"));
    } catch (e) {
      emit(TrackingError(e.toString()));
    } finally {
      _apiBusy = false;
    }
  }

  void onReached({required double complaintLat, required double complaintLng}) {
    if (!_isOnDuty) return;

    if (_lastLat == null || _lastLng == null) {
      _lastLat = complaintLat;
      _lastLng = complaintLng;
      emit(TrackingKmUpdated(_totalKm));
      return;
    }

    final meters = Geolocator.distanceBetween(
      _lastLat!,
      _lastLng!,
      complaintLat,
      complaintLng,
    );

    _totalKm += meters / 1000;

    _lastLat = complaintLat;
    _lastLng = complaintLng;

    emit(TrackingKmUpdated(_totalKm));
  }

  Future<void> offDuty({
    required int userId,
    required double lat,
    required double lng,
  }) async {
    if (!_isOnDuty || _apiBusy) return;

    _apiBusy = true;
    emit(TrackingInProgress());

    try {
      if (_lastLat != null && _lastLng != null) {
        final meters = Geolocator.distanceBetween(
          _lastLat!,
          _lastLng!,
          lat,
          lng,
        );

        _totalKm += meters / 1000;
      }

      await repository.sendTracking(
        TrackingRequestModel(
          userId: userId,
          latitude: lat,
          longitude: lng,
          km: double.parse(_totalKm.toStringAsFixed(2)),
          duty: 0,
        ),
      );

      emit(TrackingKmUpdated(_totalKm));

      _isOnDuty = false;
      _totalKm = 0;
      _lastLat = null;
      _lastLng = null;
    } on SocketException {
      emit(TrackingError("NO_INTERNET"));
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
