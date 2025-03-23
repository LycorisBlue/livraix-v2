part of 'widget.dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = '/dashboard';
  static const String name = 'DashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Données pour le graphique
  final List<double> weeklyData = [10000, 12500, 22500, 45000, 12500, 5000, 22500];
  final List<String> weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),
                const SizedBox(height: 20),
                // Stats cards
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Revenue total',
                        value: '158520 XOF',
                        valueColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Livraison totale',
                        value: '70',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Weekly stats chart
                WeeklyStatsChart(
                  weekData: weeklyData,
                  days: weekDays,
                ),
                const SizedBox(height: 30),
                // Recent deliveries
                SectionHeader(
                  title: 'Historique récents',
                  onViewAll: () {
                    // Navigation vers la page d'historique complète
                  },
                ),
                const SizedBox(height: 16),
                // Liste des livraisons récentes
                const RecentDeliveryItem(
                  title: 'Cacao',
                  id: 'H45786545215',
                  amount: '15000 XOF',
                  iconPath: 'assets/images/Box.png',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
