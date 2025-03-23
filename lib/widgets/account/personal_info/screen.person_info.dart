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
          'Mes informations personnelles',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userDetails == null
            ? const Center(
            child: Text('Aucune information utilisateur disponible'))
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ProfileHeader(
                title: 'Info personnel',
                actionText: 'MODIFIER',
                onActionPressed: () {  },
              ),
              const SizedBox(height: 24),
              // Si vous avez un logo, vous pouvez l'utiliser ici
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
                value:
                '${_userDetails?.profile.prenom} ${_userDetails?.profile.nom}',
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
                value: _userDetails?.profile.telephone ?? '',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              ProfileField(
                label: 'ADRESSE',
                value: _userDetails?.profile.addresse ?? '',
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
