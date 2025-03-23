import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livraix/models/notifications/models.devis.dart';
import 'package:livraix/models/notifications/models.notifications.dart';
import 'package:livraix/widgets/notifications/notifications_details/widget.quotation_detail.dart';
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

class QuotationHeader extends StatelessWidget {
  final Quotation quotation;

  const QuotationHeader({
    super.key,
    required this.quotation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              quotation.companyLogo,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quotation.companyName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(quotation.companyAddress),
                  Text(quotation.companyEmail),
                  Text(quotation.companyPhone),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations client',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(quotation.clientName),
              Text(quotation.clientAddress),
              Text(quotation.clientEmail),
            ],
          ),
        ),
      ],
    );
  }
}

class QuotationItemsTable extends StatelessWidget {
  final List<QuotationItem> items;

  const QuotationItemsTable({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Poids')),
          DataColumn(label: Text('Qté')),
          DataColumn(label: Text('Prix U.')),
          DataColumn(label: Text('Total')),
        ],
        rows: items.map((item) {
          return DataRow(cells: [
            DataCell(Text(item.description)),
            DataCell(Text('${item.weight} kg')),
            DataCell(Text(item.quantity.toString())),
            DataCell(Text('${item.unitPrice} XOF')),
            DataCell(Text('${item.totalPrice} XOF')),
          ]);
        }).toList(),
      ),
    );
  }
}

class QuotationFooter extends StatelessWidget {
  final Quotation quotation;

  const QuotationFooter({
    super.key,
    required this.quotation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildRouteInfo(),
              const Divider(height: 24),
              _buildTotalAmount(),
              const Divider(height: 24),
              _buildValidityInfo(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSignatureSection(),
      ],
    );
  }

  Widget _buildRouteInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lieu de récupération',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(quotation.pickupLocation),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Destination',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(quotation.destination),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Montant total',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${quotation.totalAmount} XOF',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildValidityInfo() {
    return Text(
      'Valide jusqu\'au ${DateFormat('dd/MM/yyyy').format(quotation.validUntil)}',
      style: const TextStyle(
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              const Text(
                'Signature client',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8),
              const Text(
                'Signature entreprise',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
