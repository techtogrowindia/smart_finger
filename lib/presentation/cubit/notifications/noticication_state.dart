

import 'package:smart_finger/data/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationItem> notifications;
  final int count;

  NotificationLoaded({
    required this.notifications,
    required this.count,
  });
}


class NotificationError extends NotificationState {
  final String message;
  NotificationError({required this.message});
}
