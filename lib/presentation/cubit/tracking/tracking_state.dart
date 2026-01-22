abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {}

class TrackingKmUpdated extends TrackingState {
  final double totalKm;
  TrackingKmUpdated(this.totalKm);
}

class TrackingDutyChanged extends TrackingState {
  final bool isOnDuty;
  TrackingDutyChanged(this.isOnDuty);
}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
