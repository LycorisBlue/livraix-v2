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
  String _location = 'En attente...';
  UserDetails? _userDetails;
  bool _isLoading = true;
  List<dynamic> _livraisons = [];
  final LivraisonService _livraisonService = LivraisonService();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadLocation();
    _loadLivraisons();
  }

  Future<void> _loadLivraisons() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _livraisonService.getLivraisons();

      if (result['success']) {
        List<dynamic> allLivraisons = result['data'];

        // Filtrer les livraisons où entreprise n'est pas null
        List<dynamic> filteredLivraisons = allLivraisons.where((livraison) => livraison['entreprise'] != null).toList();

        setState(() {
          _livraisons = filteredLivraisons;
          _isLoading = false;
        });
      } else {
        print('Erreur lors de la récupération des livraisons: ${result['message']}');
        setState(() {
          _livraisons = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exception lors du chargement des livraisons: $e');
      setState(() {
        _livraisons = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLocation() async {
    try {
      // Dans une application réelle, vous utiliseriez un service de géolocalisation
      // Ici, on simule une récupération de localisation
      await Future.delayed(const Duration(seconds: 1));

      // On utilise l'adresse du profil utilisateur si disponible
      if (_userDetails != null && _userDetails!.profile.addresse.isNotEmpty) {
        setState(() {
          _location = _userDetails!.profile.addresse;
        });
      } else {
        setState(() {
          _location = 'Abidjan';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération de la localisation: $e');
      setState(() {
        _location = 'Localisation indisponible';
      });
    }
  }

  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await GeneralManagerDB.getUserDetails();
      if (mounted) {
        setState(() {
          _userDetails = userDetails;
          _isLoading = false;

          // Récupérer la localisation de l'utilisateur si disponible
          if (userDetails != null && userDetails.profile.addresse.isNotEmpty) {
            _location = userDetails.profile.addresse;
          } else {
            _location = 'Localisation non définie';
          }
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _location = 'Localisation non disponible';
        });
      }
    }
  }

  void _toggleAvailability() {
    setState(() {
      _isAvailable = !_isAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          DriverProfileHeader(
            location: _location,
            isAvailable: _isAvailable,
          ),
          // Main content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // En-tête de section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            // Bouton de bascule disponibilité
                            GestureDetector(
                              onTap: _toggleAvailability,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _isAvailable ? Colors.green : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isAvailable ? Icons.check_circle_outline : Icons.cancel_outlined,
                                      color: _isAvailable ? Colors.green : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isAvailable ? 'Disponible' : 'Indisponible',
                                      style: TextStyle(
                                        color: _isAvailable ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Liste des livraisons ou état vide
                        _livraisons.isEmpty ? _buildEmptyOrdersState() : _buildLivraisonsList(),

                        const SizedBox(height: 20),

                        // Conseils pour les transporteurs
                        _buildTipsSection(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivraisonsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _livraisons.map((livraison) {
        final id = livraison['id'] ?? '';
        final product = livraison['nomProduit'] ?? 'Produit inconnu';
        final weight = livraison['poids'] ?? 0;
        final origin = livraison['adresseDepart'] ?? 'Origine inconnue';
        final destination = livraison['adresseDestination'] ?? 'Destination inconnue';
        final status = livraison['statutLivraison'] ?? 'EN_ATTENTE';
        final date = livraison['dateDeLivraison'] != null ? DateTime.parse(livraison['dateDeLivraison']) : DateTime.now();
        final entrepriseName =
            livraison['entreprise'] != null ? livraison['entreprise']['nomEntreprise'] ?? 'Entreprise' : 'Entreprise inconnue';

        // Calculer grossièrement la distance (cela serait mieux avec une API de calcul d'itinéraire)
        final distance = "Distance non calculée";
        final duration = "Durée non calculée";

        return DeliveryCard(
          title: product,
          id: id,
          pickupDate: DateFormat('dd/MM/yyyy').format(date),
          pickupWeight: "${weight}kg",
          origin: origin,
          destination: destination,
          distance: distance,
          duration: duration,
          onTap: () {
            // Ouvrir les détails de la livraison
            _showDeliveryDetails(livraison);
          },
        );
      }).toList(),
    );
  }

  void _showOfferDialog(BuildContext context, String livraisonId, String entrepriseId, String entrepriseName) {
    String selectedOption = 'ACCEPTER';
    final TextEditingController _offerController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: const Text('Discuter cette livraison'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Accepter'),
                    value: 'ACCEPTER',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Faire une offre'),
                    value: 'OFFRE',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  if (selectedOption == 'OFFRE') ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _offerController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Montant de l\'offre (XOF)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop(); // fermer le dialog
                    final webSocketManager = WebSocketManager();
                    bool success = false;

                    if (selectedOption == 'ACCEPTER') {
                      success = await webSocketManager.sendAcceptOffer(
                        livraisonId,
                        entrepriseId,
                        'Acceptée',
                      );
                    } else if (selectedOption == 'OFFRE') {
                      final montant = _offerController.text.trim();
                      if (montant.isNotEmpty) {
                        success = await webSocketManager.createLocalConversationAndSendOffer(
                          livraisonId,
                          entrepriseId,
                          entrepriseName,
                          montant,
                        );
                        if (success && context.mounted) {
                          context.pushNamed(ChatScreen.name);
                        }
                      }
                    }

                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Échec de l\'envoi du message')),
                      );
                    }
                  },
                  child: const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Méthode pour afficher les détails d'une livraison

// Méthode pour afficher les détails d'une livraison
  void _showDeliveryDetails(dynamic livraison) {
    final id = livraison['id'] ?? '';
    final product = livraison['nomProduit'] ?? 'Produit inconnu';
    final weight = livraison['poids'] ?? 0;
    final origin = livraison['adresseDepart'] ?? 'Origine inconnue';
    final destination = livraison['adresseDestination'] ?? 'Destination inconnue';
    final date = livraison['dateDeLivraison'] != null ? DateTime.parse(livraison['dateDeLivraison']) : DateTime.now();
    final entrepriseId = livraison['entreprise'] != null ? livraison['entreprise']['id'] ?? '' : '';
    final entrepriseName =
        livraison['entreprise'] != null ? livraison['entreprise']['nomEntreprise'] ?? 'Entreprise' : 'Entreprise inconnue';

    // Coordonnées pour la carte
    final latitudeDepart = livraison['latitudeDepart'] ?? 0.0;
    final longitudeDepart = livraison['longitudeDepart'] ?? 0.0;
    final latitudeDestination = livraison['latitudeDestination'] ?? 0.0;
    final longitudeDestination = livraison['longitudeDestination'] ?? 0.0;

    DeliveryDetailsBottomSheet.show(
      context,
      title: product,
      id: id,
      route: "$origin → $destination",
      distance: "Distance non calculée",
      duration: "Durée non calculée",
      date: DateFormat('dd/MM/yyyy HH:mm').format(date),
      weight: "${weight}kg",
      originCoords: LatLng(latitudeDepart, longitudeDepart),
      destinationCoords: LatLng(latitudeDestination, longitudeDestination),
      onAccept: () {
        _showOfferDialog(context, id, entrepriseId, entrepriseName);
      },
      onDecline: () {
        // Créer un WebSocketManager pour envoyer le message de refus
        final webSocketManager = WebSocketManager();

        // Envoyer un message via WebSocket pour informer l'entreprise
        webSocketManager.sendDeclineOffer(id, entrepriseId).then((success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Livraison refusée avec succès')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Échec de l\'envoi du message de refus')),
            );
          }
        });
      },
    );
  }

// Méthode pour accepter une livraison
  Future<void> _acceptLivraison(String livraisonId) async {
    try {
      // Vous devrez implémenter cette méthode dans votre service
      // final result = await _livraisonService.acceptLivraison(livraisonId);

      // Recharger les livraisons après acceptation
      _loadLivraisons();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livraison acceptée avec succès')),
      );
    } catch (e) {
      print('Erreur lors de l\'acceptation de la livraison: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'acceptation de la livraison')),
      );
    }
  }

  // Widget pour l'en-tête pendant le chargement
  Widget _buildLoadingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: const Color(0xFF074F24),
      child: Column(
        children: [
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Votre position',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  context.pushNamed(NotificationScreen.name);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white70,
                child: Icon(
                  CupertinoIcons.person_fill,
                  color: Color(0xFF074F24),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chargement...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CHARGEMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un état vide pour les commandes
  Widget _buildEmptyOrdersState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 60,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Aucune commande en attente',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Les nouvelles commandes apparaîtront ici lorsqu\'elles seront disponibles',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 20),
          if (!_isAvailable)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Vous êtes actuellement indisponible. Activez votre disponibilité pour recevoir des commandes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget pour afficher des conseils aux transporteurs
  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conseils pour les transporteurs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Gilroy',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTipItem(
                icon: Icons.timer,
                title: 'Soyez ponctuel',
                description: 'Respectez les horaires de prise en charge et de livraison',
              ),
              const Divider(height: 24),
              _buildTipItem(
                icon: Icons.verified_user_outlined,
                title: 'Vérifiez les marchandises',
                description: 'Assurez-vous que les marchandises sont en bon état avant de les accepter',
              ),
              const Divider(height: 24),
              _buildTipItem(
                icon: Icons.phone_in_talk,
                title: 'Communiquez',
                description: 'Informez régulièrement vos clients de l\'état de leur livraison',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget pour un élément de conseil
  Widget _buildTipItem({required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF074F24).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF074F24),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                  fontFamily: 'Gilroy',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Obtenir le nom de l'utilisateur
  String _getUserName() {
    if (_userDetails == null) {
      return "Transporteur";
    }

    final nom = _userDetails!.profile.nom;
    final prenom = _userDetails!.profile.prenom;

    if (nom.isEmpty && prenom.isEmpty) {
      return _userDetails!.email;
    }

    return "$prenom $nom";
  }

  // Générer un code transporteur
  String _getDriverCode() {
    if (_userDetails == null || _userDetails!.id == null) {
      return 'TRS0000';
    }

    // Générer un code à partir de l'ID (utiliser les 6 premiers caractères)
    final id = _userDetails!.id!;
    if (id.length >= 6) {
      return 'TRS${id.substring(0, 4).toUpperCase()}';
    }

    return 'TRS${id.toUpperCase()}';
  }
}
