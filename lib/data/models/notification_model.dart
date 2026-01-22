class NotificationResponse {
  final int count;
  final List<NotificationItem> notifications;

  NotificationResponse({
    required this.count,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      count: json['count'] ?? 0,
      notifications: (json['notifications'] as List)
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
    );
  }
}

class NotificationItem {
  final int id;
  final int complaintId;
  final String content;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.complaintId,
    required this.content,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      complaintId: json['complaint_id'],
      content: json['content'],
      createdAt: json['created_at'],
    );
  }
}
