part of 'widget.forgot_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String path = '/forgotpassword';
  static const String name = 'Forgotpassword';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement API integration later
      showDialog(
        context: context,
        builder: (context) => SuccessDialog(
          title: 'Vérifiez votre e-mail',
          message: 'Nous vous avons envoyé un lien de rénitialisation en vue de changer votre mot de passe',
          buttonText: 'Retour',
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Return to login screen
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Mot de passe oublié',
              subtitle: 'Entrez votre email pour rénitialiser le mot de passe',
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: double.infinity,
                        // height: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Lottie.asset(
                          'assets/animations/forgot.json',
                          fit: BoxFit.cover,
                          repeat: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Veuillez entrer votre email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                      text: 'Rénitialiser',
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: _resetPassword,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}