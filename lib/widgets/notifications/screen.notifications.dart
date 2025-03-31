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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simuler un délai de chargement
      await Future.delayed(const Duration(milliseconds: 800));

      // Aucune notification n'est disponible
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des notifications: $e');
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
    }
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
        actions: [
          // Bouton de rafraîchissement
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildFilterSection(),
              _isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    )
                  : _notifications.isEmpty
                      ? _buildEmptyState()
                      : Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredNotifications.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              return NotificationItem(
                                notification: _filteredNotifications[index],
                                onTap: () {},
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

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône de notification
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),

              // Titre
              const Text(
                'Aucune notification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Vous n\'avez pas encore reçu de notifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Les mises à jour concernant vos livraisons et devis apparaîtront ici',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),

              // Types de notifications
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Types de notifications que vous recevrez:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNotificationType(
                      icon: Icons.description_outlined,
                      color: Colors.blue,
                      title: 'Nouveaux devis',
                      description: 'Lorsqu\'un nouveau devis est disponible pour une demande',
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationType(
                      icon: Icons.local_shipping_outlined,
                      color: Colors.orange,
                      title: 'Mises à jour de statut',
                      description: 'Lorsque le statut d\'une livraison change',
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationType(
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                      title: 'Services acceptés',
                      description: 'Lorsqu\'une demande de transport est acceptée',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bouton pour rafraîchir
              TextButton.icon(
                onPressed: _loadNotifications,
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Rafraîchir'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationType({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
