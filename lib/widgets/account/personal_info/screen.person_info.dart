part of 'widget.personal_info.dart';

class CustomerPersonalInfoScreen extends StatefulWidget {
  const CustomerPersonalInfoScreen({super.key});

  @override
  State<CustomerPersonalInfoScreen> createState() => _CustomerProfileState();

  static const name = 'customerpersonalinfo';
  static const path = 'customerpersonalinfo';
}

class _CustomerProfileState extends State<CustomerPersonalInfoScreen> {
  UserDetails? _userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _userDetails == null
                ? const Center(child: Text('Aucune information utilisateur disponible'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ProfileHeader(
                          title: 'Info personnel',
                          actionText: 'MODIFIER',
                          onActionPressed: () {
                            // Action pour modifier les informations personnelles
                          },
                        ),
                        const SizedBox(height: 24),
                        const ProfileAvatar(
                            //imageUrl: _userDetails?.profile.logo,
                            ),
                        const SizedBox(height: 16),
                        Text(
                          '${_userDetails?.profile.prenom} ${_userDetails?.profile.nom}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ProfileField(
                          label: 'NOM COMPLET',
                          value: '${_userDetails?.profile.prenom} ${_userDetails?.profile.nom}',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        ProfileField(
                          label: 'EMAIL',
                          value: _userDetails?.email ?? '',
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 16),
                        ProfileField(
                          label: 'CONTACT',
                          value: _userDetails?.profile.telephone ?? 'Non renseigné',
                          icon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 16),
                        ProfileField(
                          label: 'ADRESSE',
                          value: _userDetails?.profile.addresse.isNotEmpty ?? false
                              ? _userDetails!.profile.addresse
                              : 'Non renseignée',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),
                        ProfileField(
                          label: 'RÔLE',
                          value: _userDetails?.roles.isNotEmpty ?? false ? _formatRole(_userDetails!.roles[0]) : 'Utilisateur',
                          icon: Icons.work_outline,
                        ),
                        const SizedBox(height: 16),
                        ProfileField(
                          label: 'STATUT DU COMPTE',
                          value: _userDetails?.status ?? false ? 'Actif' : 'Inactif',
                          icon: Icons.verified_user_outlined,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  String _formatRole(String role) {
    switch (role.toUpperCase()) {
      case 'TRANSPORTEUR':
        return 'Transporteur';
      case 'ENTREPRISE':
        return 'Entreprise';
      case 'ADMIN':
        return 'Administrateur';
      default:
        return role;
    }
  }
}
