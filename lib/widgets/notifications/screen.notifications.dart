part of 'widget.notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String path = '/notification';
  static const String name = 'Notification';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<FreightNotification> _notifications;
  String _selectedFilter = 'Tous';
  FreightNotification? _selectedNotification;

  @override
  void initState() {
    super.initState();
    _notifications = _mockNotifications;
  }

  List<FreightNotification> get _filteredNotifications {
    if (_selectedFilter == 'Tous') return _notifications;
    return _notifications.where((notification) {
      switch (_selectedFilter) {
        case 'Accepté':
          return notification.type == NotificationType.serviceAccepted;
        case 'Refusé':
          return notification.type == NotificationType.statusChange;
        default:
          return true;
      }
    }).toList();
  }

  void _handleFilterChange(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final notification = _notifications[index];
        _notifications[index] = FreightNotification(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          type: notification.type,
          isRead: true,
          data: notification.data,
        );
      }
    });
  }

  void _handleNotificationTap(FreightNotification notification) {
    _markAsRead(notification.id);

    // Afficher le popup de détail de notification
    setState(() {
      _selectedNotification = notification;
    });
  }

  void _closeNotificationDetail() {
    setState(() {
      _selectedNotification = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildFilterSection(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredNotifications.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return NotificationItem(
                      notification: _filteredNotifications[index],
                      onTap: () => _handleNotificationTap(_filteredNotifications[index]),
                    );
                  },
                ),
              ),
            ],
          ),

          // Popup de détail de notification
          if (_selectedNotification != null)
            NotificationDetailPopup(
              notification: _selectedNotification!,
              onClose: _closeNotificationDetail,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Tous',
            isSelected: _selectedFilter == 'Tous',
            onTap: () => _handleFilterChange('Tous'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Accepté',
            isSelected: _selectedFilter == 'Accepté',
            onTap: () => _handleFilterChange('Accepté'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Refusé',
            isSelected: _selectedFilter == 'Refusé',
            onTap: () => _handleFilterChange('Refusé'),
          ),
        ],
      ),
    );
  }

  // Mock data for demonstration
  static final List<FreightNotification> _mockNotifications = [
    FreightNotification(
      id: '1',
      title: 'Nouveau devis reçu',
      message: 'Un nouveau devis est disponible pour votre demande de transport de marchandises entre Abidjan et Bouaké.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.quotation,
      data: {
        'quotationId': 'Q123',
        'companyName': 'Transport Express CI',
        'pickupLocation': 'Abidjan, Treichville',
        'destination': 'Bouaké',
        'amount': '75000'
      },
    ),
    FreightNotification(
      id: '2',
      title: 'Statut mis à jour',
      message:
          'Votre livraison est en cours de transport. Le chauffeur a quitté le point de départ et est en route vers la destination.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.statusChange,
      data: {
        'serviceId': 'S456',
        'newStatus': 'En cours de livraison',
        'vehicleInfo': 'Camion benne - AH 1234 CI',
        'driverName': 'Kouadio Jean'
      },
    ),
    FreightNotification(
      id: '3',
      title: 'Service accepté',
      message:
          'Votre demande de transport a été acceptée par un transporteur. Vos marchandises seront prises en charge à la date convenue.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotificationType.serviceAccepted,
      data: {
        'serviceId': 'S789',
        'transporterName': 'Bakary Touré',
        'deliveryDate': '23/03/2025',
        'vehicleType': 'Camion frigorifique'
      },
    ),
    FreightNotification(
      id: '4',
      title: 'Devis mis à jour',
      message: 'Le devis pour votre transport de café a été révisé suite à votre demande de modification de poids.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.quotation,
      data: {
        'quotationId': 'Q124',
        'companyName': 'LogiFreight CI',
        'pickupLocation': 'Daloa',
        'destination': 'Abidjan, Port',
        'amount': '120000'
      },
    ),
    FreightNotification(
      id: '5',
      title: 'Livraison terminée',
      message: 'Votre livraison de cacao a été livrée avec succès à destination. Veuillez confirmer la réception.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.statusChange,
      data: {'serviceId': 'S457', 'newStatus': 'Livré', 'product': 'Cacao - 500kg', 'deliveryTime': '10:45'},
    ),
  ];
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
