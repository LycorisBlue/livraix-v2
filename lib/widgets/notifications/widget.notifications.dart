import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livraix/models/notifications/models.notifications.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.notifications.dart';

class NotificationItem extends StatelessWidget {
  final FreightNotification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.quotation:
        iconData = Icons.description_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.statusChange:
        iconData = Icons.local_shipping_outlined;
        iconColor = Colors.orange;
        break;
      case NotificationType.serviceAccepted:
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }
}

class NotificationDetailPopup extends StatelessWidget {
  final FreightNotification notification;
  final VoidCallback onClose;

  const NotificationDetailPopup({
    super.key,
    required this.notification,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de la notification
              Row(
                children: [
                  _buildNotificationIcon(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Corps de la notification
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  notification.message,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Détails supplémentaires en fonction du type
              _buildNotificationDetails(),
              const SizedBox(height: 24),

              // Bouton de fermeture
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Fermer',
                  color: AppColors.primary,
                  textColor: Colors.white,
                  onPressed: onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.quotation:
        iconData = Icons.description_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.statusChange:
        iconData = Icons.local_shipping_outlined;
        iconColor = Colors.orange;
        break;
      case NotificationType.serviceAccepted:
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 28),
    );
  }

  Widget _buildNotificationDetails() {
    switch (notification.type) {
      case NotificationType.quotation:
        return _buildQuotationDetails();
      case NotificationType.statusChange:
        return _buildStatusChangeDetails();
      case NotificationType.serviceAccepted:
        return _buildServiceAcceptedDetails();
    }
  }

  Widget _buildQuotationDetails() {
    final quotationData = notification.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails du devis',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Entreprise', quotationData['companyName'] ?? 'Non spécifié'),
        _buildDetailRow('De', quotationData['pickupLocation'] ?? 'Non spécifié'),
        _buildDetailRow('À', quotationData['destination'] ?? 'Non spécifié'),
        _buildDetailRow('Montant', '${quotationData['amount'] ?? '0'} XOF'),
      ],
    );
  }

  Widget _buildStatusChangeDetails() {
    final statusData = notification.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mise à jour du statut',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Service', statusData['serviceId'] ?? 'Non spécifié'),
        _buildDetailRow('Nouveau statut', statusData['newStatus'] ?? 'Non spécifié'),
        _buildDetailRow('Mise à jour le', _formatTimestamp(notification.timestamp)),
      ],
    );
  }

  Widget _buildServiceAcceptedDetails() {
    final serviceData = notification.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service accepté',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Service', serviceData['serviceId'] ?? 'Non spécifié'),
        _buildDetailRow('Transporteur', serviceData['transporterName'] ?? 'Non spécifié'),
        _buildDetailRow('Date de livraison', serviceData['deliveryDate'] ?? 'Non spécifié'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes}min';
    } else {
      return 'À l\'instant';
    }
  }
}
