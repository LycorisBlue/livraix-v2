part of 'widget.signup.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String path = '/signup';
  static const String name = 'SignupScreen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController(); // Ajouté pour prenom
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _vehicleRegistrationController = TextEditingController();
  final _locationController = TextEditingController(); // Ajouté pour localisation
  
  // Instance du service d'authentification
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool? _hasLicense;
  bool? _hasTruckBenne;
  bool? _hasTruckCiterne;
  bool? _hasInsurance;
  bool _isLoading = false; // Pour afficher un indicateur de chargement

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseNumberController.dispose();
    _vehicleRegistrationController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Vérifier si les champs de choix sont sélectionnés
      if (_hasLicense == null) {
        _showValidationError('Veuillez indiquer si vous avez une licence');
        return;
      }

      if (_hasTruckBenne == null && _hasTruckCiterne == null) {
        _showValidationError('Veuillez sélectionner un type de véhicule');
        return;
      }

      if (_hasInsurance == null) {
        _showValidationError('Veuillez indiquer si vous avez une assurance');
        return;
      }

      // Déterminer le type de camion
      String camionType = _hasTruckBenne == true ? 'BENNE' : 'CITERNE';

      setState(() {
        _isLoading = true;
      });

      try {
        // Appel au service d'enregistrement
        final result = await _authService.register(
          nom: _nameController.text,
          prenom: _surnameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          numeroPermis: _licenseNumberController.text,
          licence: _hasLicense!,
          localisation: _locationController.text.isNotEmpty ? _locationController.text : 'Non spécifiée',
          numMatriculation: _vehicleRegistrationController.text,
          camionType: camionType,
          assurance: _hasInsurance!,
        );

        setState(() {
          _isLoading = false;
        });

        if (result['success']) {
          // Succès de l'enregistrement
          _showSuccessDialog(result['message']);
        } else {
          // Échec de l'enregistrement
          _showValidationError(result['message']);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showValidationError('Une erreur s\'est produite: ${e.toString()}');
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: 'Inscription réussie',
        message: message,
        buttonText: 'Se connecter',
        onPressed: () {
          Navigator.of(context).pop(); // Fermer le dialogue
          context.pushNamed(EmailVerificationScreen.name); // Naviguer vers l'écran de connexion
        },
      ),
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
                  title: 'S\'inscrire',
                  subtitle: 'Créez votre compte transporteur',
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informations personelles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF074F24),
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom',
                          hintText: 'Votre nom',
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre nom' : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _surnameController,
                          label: 'Prénom',
                          hintText: 'Votre prénom',
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre prénom' : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'votre.email@exemple.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            // Basic email regex pattern
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Mot de passe',
                          hintText: '••••••••••',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre mot de passe' : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _licenseNumberController,
                          label: 'Numéro de permis',
                          hintText: '2106921069990',
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre numéro de permis' : null,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _locationController,
                          label: 'Localisation',
                          hintText: 'Votre ville ou région',
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre localisation' : null,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Avez-vous une licence',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomRadioButton(
                                text: 'Oui',
                                isSelected: _hasLicense == true,
                                onChanged: (value) {
                                  setState(() {
                                    _hasLicense = value ? true : null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomRadioButton(
                                text: 'Non',
                                isSelected: _hasLicense == false,
                                onChanged: (value) {
                                  setState(() {
                                    _hasLicense = value ? false : null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Informations sur le véhicule',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF074F24),
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomRadioButton(
                              text: 'Camion benne',
                              isSelected: _hasTruckBenne == true,
                              onChanged: (value) {
                                setState(() {
                                  _hasTruckBenne = value ? true : null;
                                  if (value) {
                                    _hasTruckCiterne = false;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomRadioButton(
                              text: 'Camion citerne',
                              isSelected: _hasTruckCiterne == true,
                              onChanged: (value) {
                                setState(() {
                                  _hasTruckCiterne = value ? true : null;
                                  if (value) {
                                    _hasTruckBenne = false;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _vehicleRegistrationController,
                          label: 'Numéro d\'immatriculation',
                          hintText: '2106921069990',
                          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre numéro d\'immatriculation' : null,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Avez-vous une assurance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomRadioButton(
                                text: 'Oui',
                                isSelected: _hasInsurance == true,
                                onChanged: (value) {
                                  setState(() {
                                    _hasInsurance = value ? true : null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomRadioButton(
                                text: 'Non',
                                isSelected: _hasInsurance == false,
                                onChanged: (value) {
                                  setState(() {
                                    _hasInsurance = value ? false : null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        CustomButton(
                          text: 'S\'inscrire',
                          color: const Color(0xFF074F24),
                          textColor: Colors.white,
                          onPressed: _isLoading
                              ? () {}
                              : () {
                                  _register(); // Appelle la fonction asynchrone sans attendre
                                },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'J\'ai un compte ? ',
                                style: TextStyle(fontSize: 14),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(LoginScreen.name);
                                },
                                child: const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    color: Color(0xFF074F24),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text,
            fontFamily: 'Gilroy',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.textLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.textLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF074F24)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}