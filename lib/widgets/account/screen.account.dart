part of 'widget.account.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileState();

  static const path = '/customer_profile';
  static const name = 'customerprofile';
}

class _CustomerProfileState extends State<CustomerProfileScreen> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mon Compte'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ProfileSection(
                items: [
                  ProfileItemModel(icon: Icons.person_outline, label: 'Info Personnel'),
                  // ProfileItemModel(icon: Icons.newspaper_outlined,
                  //     label: 'Activer Mon Compte'),
                  ProfileItemModel(icon: Icons.location_on_outlined, label: 'Adresses'),
                ],
              ),
              ProfileSection(
                items: [
                  ProfileItemModel(icon: Icons.shopping_cart_outlined, label: 'Mes Commandes'),
                  ProfileItemModel(icon: Icons.favorite_outline, label: 'Mes Favoris'),
                  ProfileItemModel(icon: Icons.notifications_none, label: 'Notifications'),
                ],
              ),
              ProfileSection(
                items: [
                  ProfileItemModel(icon: Icons.help_outline, label: 'FAQs'),
                  ProfileItemModel(icon: Icons.feedback_outlined, label: 'Mes Feedback'),
                  ProfileItemModel(icon: Icons.settings_outlined, label: 'Paramètres'),
                ],
              ),
              ProfileSection(
                items: [
                  ProfileItemModel(
                    icon: Icons.update,
                    label: 'Mise à jour',
                    iconColor: Colors.blue,
                  ),
                ],
              ),
              ProfileSection(
                items: [
                  ProfileItemModel(
                    icon: Icons.logout,
                    label: 'Se Déconnecter',
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
