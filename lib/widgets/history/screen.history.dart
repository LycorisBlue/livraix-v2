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

  final List<DeliveryHistory> _deliveries = [
    DeliveryHistory(
      id: 'H45786545215',
      product: 'Cacao',
      from: 'Treichville, Abidjan',
      to: 'Abolsso',
      status: 'En attente',
    ),
    DeliveryHistory(
      id: 'H45786545215',
      product: 'Cacao',
      from: 'Treichville, Abidjan',
      to: 'Abolsso',
      status: 'Accepté',
    ),
    DeliveryHistory(
      id: 'H45786545215',
      product: 'Noix de cajou',
      from: 'Dabou',
      to: 'Abolsso',
      status: 'Refusé',
    ),
    DeliveryHistory(
      id: 'H45786545215',
      product: 'Café',
      from: 'Dabakala',
      to: 'Abolsso',
      status: 'Accepté',
    ),
  ];

  List<DeliveryHistory> get filteredDeliveries {
    if (_selectedFilter == 'Tous') return _deliveries;
    return _deliveries.where((d) => d.status == _selectedFilter).toList();
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = filteredDeliveries[index];
                return GestureDetector( onTap: () => context.pushNamed(ContractDetailsScreen.name),child: HistoryItem(delivery: delivery));
              },
            ),
          ),
        ],
      ),
    );
  }
}
