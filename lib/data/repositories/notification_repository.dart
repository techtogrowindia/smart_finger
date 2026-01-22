import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService service;

  NotificationRepository({required this.service});

  Future<NotificationResponse> fetchNotifications() {
    return service.getNotifications();
  }
}
