part of 'widget.dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = '/dashboard';
  static const String name = 'DashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Données utilisateur
  UserDetails? _userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Charger les détails de l'utilisateur
      final userDetails = await GeneralManagerDB.getUserDetails();

      setState(() {
        _userDetails = userDetails;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          'Bienvenue, ${_getUserName()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // État vide pour la bannière de solde
                      _buildEmptyBalanceBanner(),

                      // État vide pour les cartes statistiques
                      Row(
                        children: [
                          Expanded(
                            child: _buildEmptyStatCard(
                              title: 'Revenue',
                              message: 'Aucune donnée disponible',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildEmptyStatCard(
                              title: 'Livraisons',
                              message: 'Aucune donnée disponible',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // État vide pour le graphique
                      _buildEmptyChart(),
                      const SizedBox(height: 30),

                      // En-tête de section pour l'historique
                      const SectionHeader(
                        title: 'Historique récent',
                        onViewAll: null, // Désactivé car aucune donnée
                      ),
                      const SizedBox(height: 16),

                      // État vide pour l'historique
                      _buildEmptyHistory(),

                      const SizedBox(height: 20),

                      // Information sur le compte utilisateur
                      if (_userDetails != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_outline, color: AppColors.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Informations du compte',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Rôle: ${_userDetails!.roles.isNotEmpty ? _userDetails!.roles[0] : "Transporteur"}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                onPressed: () {
                                  // Navigation vers la page de profil
                                  context.pushNamed(CustomerProfileScreen.name);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Widget pour afficher une bannière de solde vide
  Widget _buildEmptyBalanceBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF074F24),
            const Color(0xFF074F24).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Solde disponible',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'En attente de données',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'À venir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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

  // Widget pour afficher une carte statistique vide
  Widget _buildEmptyStatCard({required String title, required String message}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
              fontFamily: 'Gilroy',
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher un graphique vide
  Widget _buildEmptyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Gilroy',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 48,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune donnée statistique disponible',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontFamily: 'Gilroy',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Les statistiques seront affichées ici lorsque vous aurez effectué des livraisons',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget pour afficher un historique vide
  Widget _buildEmptyHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun historique de livraison',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos livraisons récentes apparaîtront ici',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontFamily: 'Gilroy',
            ),
          ),
        ],
      ),
    );
  }
}
