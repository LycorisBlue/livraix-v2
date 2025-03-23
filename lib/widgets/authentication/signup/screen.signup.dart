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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _vehicleRegistrationController = TextEditingController();

  bool _obscurePassword = true;
  bool? _hasLicense;
  bool? _hasTruckBenne;
  bool? _hasTruckCiterne;
  bool? _hasInsurance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _licenseNumberController.dispose();
    _vehicleRegistrationController.dispose();
    super.dispose();
  }

  void _register() {
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

      // Implémenter l'intégration de l'API ici
      print('Driver registration submitted');
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('License: $_hasLicense');
      print('Vehicle type: ${_hasTruckBenne == true ? 'Benne' : _hasTruckCiterne == true ? 'Citerne' : 'None'}');
      print('Has insurance: $_hasInsurance');
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'S\'inscrire',
              subtitle: 'Créez votre compte',
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
                      label: 'Nom complet',
                      hintText: 'Jon Doe',
                      validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer votre nom' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Jondoe@gmail.com',
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
                      onPressed: _register,
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
