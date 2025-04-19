
enum NotificationType {
  statusChange,
  quotation,
  serviceAccepted,
  serviceDeclined // Ajout d'un type pour le refus
}

class FreightNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic> data;

  FreightNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    required this.data,
  });
}