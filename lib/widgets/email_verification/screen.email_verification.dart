part of 'widget.email_verification.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  static const String path = '/email-verification';
  static const String name = 'EmailVerification';

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  // Contrôleurs pour chaque chiffre du code
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // Focus nodes pour chaque champ
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  final AuthService _verificationService = AuthService();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    // Libérer les contrôleurs et focus nodes
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Obtenir le code complet
  String get _completeCode {
    return _codeControllers.map((controller) => controller.text).join();
  }

  // Vérifier si le code est complet (tous les champs remplis)
  bool get _isCodeComplete {
    return _codeControllers.every((controller) => controller.text.isNotEmpty);
  }

  // Gérer le changement de valeur d'un champ
  void _handleDigitChange(int index, String value) {
    // Si une valeur est entrée et ce n'est pas le dernier champ, passer au suivant
    if (value.isNotEmpty && index < _codeControllers.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Si le code est complet, vérifier automatiquement
    if (_isCodeComplete) {
      _verifyCode();
    }
  }

  // Vérifier le code auprès de l'API
  Future<void> _verifyCode() async {
    if (!_isCodeComplete) {
      setState(() {
        _errorMessage = 'Veuillez entrer le code complet';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _verificationService.verifyEmailCode(_completeCode);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        // Afficher un dialogue de succès
        _showSuccessDialog(result['message']);
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Une erreur s\'est produite: ${e.toString()}';
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        title: 'Vérification réussie',
        message: message,
        buttonText: 'Se connecter',
        onPressed: () {
          Navigator.of(context).pop(); // Fermer le dialogue
          context.pushNamed(LoginScreen.name); // Naviguer vers l'écran de connexion
        },
      ),
    );
  }

  // Renvoyer le code par email
  void _resendCode() {
    // Logique pour renvoyer le code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Un nouveau code a été envoyé à votre adresse email'),
        backgroundColor: Color(0xFF074F24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF074F24),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AuthHeader(
                  title: 'Vérification par email',
                  subtitle: 'Saisissez le code reçu par email',
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icône de vérification
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF074F24).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF074F24),
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Message explicatif
                      Text(
                        'Nous avons envoyé un code de vérification à ${widget.email}. Le code expirera dans 10 minutes.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Champs de saisie du code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: DigitField(
                                controller: _codeControllers[index],
                                focusNode: _focusNodes[index],
                                onChanged: (value) => _handleDigitChange(index, value),
                              ),
                            );
                          },
                        ),
                      ),

                      // Message d'erreur
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Bouton de vérification
                      CustomButton(
                        text: 'Vérifier',
                        color: const Color(0xFF074F24),
                        textColor: Colors.white,
                        onPressed: _isLoading
                            ? () {}
                            : () {
                                _verifyCode();
                              },
                      ),

                      const SizedBox(height: 24),

                      // Option pour renvoyer le code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Vous n\'avez pas reçu de code ? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: _resendCode,
                            child: const Text(
                              'Renvoyer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF074F24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Indicateur de chargement
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF074F24),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
