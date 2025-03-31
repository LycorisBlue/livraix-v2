part of 'widget.history.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static const String path = '/history';
  static const String name = 'History';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'Tous';
  bool _isLoading = true;
  List<DeliveryHistory> _deliveries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simuler le chargement des données
    setState(() {
      _isLoading = true;
    });

    // Dans une application réelle, vous chargeriez les données depuis une API
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      // Liste vide car aucune donnée n'est disponible
      _deliveries = [];
      _isLoading = false;
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
          'Historique',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          HistoryFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
          ),
          _isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF074F24)),
                  ),
                )
              : _deliveries.isEmpty
                  ? _buildEmptyState()
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _deliveries.length,
                        itemBuilder: (context, index) {
                          final delivery = _deliveries[index];
                          return GestureDetector(
                            onTap: () => context.pushNamed(ContractDetailsScreen.name),
                            child: HistoryItem(delivery: delivery),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône illustrative
              Icon(
                Icons.history_outlined,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 24),
              // Titre de l'état vide
              Text(
                'Aucun historique disponible',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                'Vos livraisons terminées apparaîtront ici',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              // Information supplémentaire
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF074F24).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Acceptez des commandes sur la page d\'accueil pour commencer à construire votre historique',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF074F24),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Bouton pour rafraîchir (optionnel)
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh, color: Color(0xFF074F24)),
                label: const Text(
                  'Rafraîchir',
                  style: TextStyle(
                    color: Color(0xFF074F24),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  backgroundColor: const Color(0xFF074F24).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
