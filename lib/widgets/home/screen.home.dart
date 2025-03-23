part of 'widget.home.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String path = '/home';
  static const String name = 'Home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header with driver profile
          DriverProfileHeader(
            driverName: 'Kouadio Jean',
            driverCode: 'TRS4220',
            location: 'Dabou',
            isAvailable: _isAvailable,
            profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          ),
      
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Commandes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DeliveryCard(
                    title: 'Cacao',
                    id: 'H4578654521S',
                    pickupDate: 'Aujourd\'hui',
                    pickupWeight: '4Kg',
                    origin: 'Treichville, Abidjan',
                    destination: 'Dabou',
                    distance: '22,4 km',
                    duration: '2 heures 25 min',
                    onTap: () {
                      DeliveryDetailsBottomSheet.show(
                        context,
                        title: 'Cacao',
                        id: 'H4578654521S',
                        route: 'Treichville, Abidjan - Dabou',
                        distance: '22,4 km',
                        duration: '2 heures 25 min',
                        date: 'Aujourd\'hui',
                        weight: '4Kg',
                        onDecline: () {
                          // Action quand le chauffeur rejette la livraison
                          print('Livraison rejetée');
                        },
                        onAccept: () {
                          // Action quand le chauffeur accepte la livraison
                          print('Livraison acceptée');
                        },
                      );
                    },
                  ),
                    DeliveryCard(
                    title: 'Noix de cajou',
                    id: 'H4568654521S',
                    pickupDate: 'Demain',
                    pickupWeight: '12Kg',
                    origin: 'Treichville, Abidjan',
                    destination: 'Dabou',
                    distance: '22,4 km',
                    duration: '2 heures 25 min',
                    onTap: () {
                      DeliveryDetailsBottomSheet.show(
                      context,
                      title: 'Noix de cajou',
                      id: 'H4568654521S',
                      route: 'Treichville, Abidjan - Dabou',
                      distance: '22,4 km',
                      duration: '2 heures 25 min',
                      date: 'Demain',
                      weight: '12Kg',
                      onDecline: () {
                        print('Livraison rejetée');
                      },
                      onAccept: () {
                        print('Livraison acceptée');
                      },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
