part of 'widget.ask_service.dart';

class DeliveryRequestServiceScreen extends StatefulWidget {
  const DeliveryRequestServiceScreen({super.key});

  static const String path = '/deliveryrequestservice';
  static const String name = 'Deliveryrequestservice';

  @override
  State<DeliveryRequestServiceScreen> createState() =>
      _DeliveryRequestServiceScreenState();
}

class _DeliveryRequestServiceScreenState
    extends State<DeliveryRequestServiceScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtenir la hauteur de la bottom navigation bar
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails de livraison',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom:
                bottomPadding + 20.0, // Ajout du padding supplémentaire en bas
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeliveryAddressSection(),
              SizedBox(height: 24),
              RecipientInfoSection(),
              SizedBox(height: 24),
              ProductInfoSection(),
              SizedBox(height: 24),
              VehicleSelectionSection(),
              SizedBox(height: 24),
              PaymentMethodSection(),
              SizedBox(height: 24),
              DateTimeSelectionSection(),
            ],
          ),
        ),
      ),
    );
  }
}
