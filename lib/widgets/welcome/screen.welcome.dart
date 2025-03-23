part of 'widget.welcome.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String path = '/';
  static const String name = 'WelcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image illustration
              Image.asset(
                'assets/images/Delivery_illustration.png',
                height: 250,
              ),
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'Simplifiez le transport de\nvos marchandises',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              const Text(
                'Réservez des transports en quelques clics\net suivez vos marchandises en temps réel\nà travers toute la Côte d\'Ivoire.',
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Login Button
              CustomButton(
                text: 'Se connecter',
                color: AppColors.primary,
                textColor: Colors.white,
                onPressed: () {
                  // context.pushNamed(LoginScreen.name);
                  // context.pushNamed(ContractDetailsScreen.name);
                  context.pushNamed(HomeScreen.name);
                },
              ),
              const SizedBox(height: 16),
              
              // Register Button
              CustomButton(
                text: 'S\'inscrire',
                color: Colors.white,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                onPressed: () { 
                  context.pushNamed(SignupScreen.name);
                },
              ),
              
              const SizedBox(height: 20),
              
              // Terms and Privacy
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.small.copyWith(color: Colors.grey),
                  children: [
                    const TextSpan(
                      text: 'En vous inscrivant ou en vous connectant, vous acceptez nos ',
                    ),
                    TextSpan(
                      text: 'Conditions d\'utilisation',
                      style: AppTextStyles.small.copyWith(color: AppColors.primary),
                    ),
                    const TextSpan(text: ' et notre '),
                    TextSpan(
                      text: 'Politique de confidentialité',
                      style: AppTextStyles.small.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}