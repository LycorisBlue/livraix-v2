part of 'widget.contract_details.dart';

class ContractDetailsScreen extends StatefulWidget {

  const ContractDetailsScreen({
    super.key,
  });

  static const String path = '/contract';
  static const String name = 'ContractDetails';

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  // Dans une application réelle, ces informations seraient récupérées
  // depuis une API ou une base de données locale
  late final Map<String, dynamic> _contractData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContractDetails();
  }

  Future<void> _fetchContractDetails() async {
    // Simulation d'un appel API
    await Future.delayed(const Duration(milliseconds: 800));

    // Dans un cas réel, ces données seraient récupérées depuis une API
    _contractData = {
      'id': "OP09OK11",
      'status': 'Confirmé',
      'creationDate': DateTime.now(),
      'client': {
        'name': 'Amadou Koné',
        'phone': '+225 0701020304',
        'email': 'amadou.kone@example.com',
      },
      'transporter': {
        'name': 'Bakary Touré',
        'phone': '+225 0705060708',
        'vehicleInfo': 'Camion Renault - AH 1234 CI',
      },
      'delivery': {
        'origin': 'Treichville, Abidjan',
        'destination': 'Yopougon, Abidjan',
        'product': 'Cacao - 500kg',
        'price': '75 000 FCFA',
        'expectedDeliveryDate': DateTime.now().add(const Duration(days: 2)),
      },
      'signatures': {
        'client': 'assets/images/png-transparent-digital-signature-handwriting-signature-block-narcissism-email-love-miscellaneous-angle-thumbnail.png',
        'transporter': null, // Pas encore signé
      }
    };

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Détails du contrat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // Fonctionnalité de partage du contrat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partage du contrat...')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF074F24)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContractHeader(
                    contractId: _contractData['id'],
                    creationDate: _contractData['creationDate'],
                  ),
                  const SizedBox(height: 24),
                  ContractSection(
                    title: 'Informations du client',
                    details: [
                      ContractDetail(
                        label: 'Nom',
                        value: _contractData['client']['name'],
                      ),
                      ContractDetail(
                        label: 'Téléphone',
                        value: _contractData['client']['phone'],
                      ),
                      ContractDetail(
                        label: 'Email',
                        value: _contractData['client']['email'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ContractSection(
                    title: 'Informations du transporteur',
                    details: [
                      ContractDetail(
                        label: 'Nom',
                        value: _contractData['transporter']['name'],
                      ),
                      ContractDetail(
                        label: 'Téléphone',
                        value: _contractData['transporter']['phone'],
                      ),
                      ContractDetail(
                        label: 'Véhicule',
                        value: _contractData['transporter']['vehicleInfo'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ContractSection(
                    title: 'Détails de la livraison',
                    details: [
                      ContractDetail(
                        label: 'Départ',
                        value: _contractData['delivery']['origin'],
                      ),
                      ContractDetail(
                        label: 'Destination',
                        value: _contractData['delivery']['destination'],
                      ),
                      ContractDetail(
                        label: 'Marchandise',
                        value: _contractData['delivery']['product'],
                      ),
                      ContractDetail(
                        label: 'Prix',
                        value: _contractData['delivery']['price'],
                      ),
                      ContractDetail(
                        label: 'Date prévue',
                        value: DateFormat('dd/MM/yyyy').format(_contractData['delivery']['expectedDeliveryDate']),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Signatures',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF074F24),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SignatureSection(
                    clientName: _contractData['client']['name'],
                    transporterName: _contractData['transporter']['name'],
                    clientSignatureUrl: _contractData['signatures']['client'],
                    transporterSignatureUrl: _contractData['signatures']['transporter'],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: !_isLoading
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action pour télécharger ou imprimer le contrat
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Téléchargement du contrat...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF074F24),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Télécharger le contrat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
