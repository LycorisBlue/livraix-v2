import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:livraix/widgets/authentication/forgot_password/widget.forgot_password.dart';
import 'package:livraix/widgets/home/widget.home.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.ask_service.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adresse de livraison',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              _AddressField(
                label: 'De',
                value: 'Treichville, Abidjan',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              _AddressField(
                label: 'Livré à',
                value: 'Dabou',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  final String label;
  final String value;

  const _AddressField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Widget pour la section d'info

class RecipientInfoSection extends StatelessWidget {
  const RecipientInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: TextEditingController(),
          label: 'Nom du destinataire',
          prefixIcon: const Icon(Icons.person_outline),
          backgroundColor: Colors.grey[50]!,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: TextEditingController(),
          label: 'Numéro destinataire',
          prefixIcon: const Icon(Icons.phone_outlined),
          keyboardType: TextInputType.phone,
          backgroundColor: Colors.grey[50]!,
        ),
      ],
    );
  }
}

// Widget de la section d'info de la marchandise

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Information sur le produit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: TextEditingController(),
          label: 'Nom du produit',
          prefixIcon: const Icon(Icons.inventory_2_outlined),
          backgroundColor: Colors.grey[50]!,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: TextEditingController(),
          label: 'Poids approximatif',
          prefixIcon: const Icon(Icons.scale_outlined),
          keyboardType: TextInputType.number,
          backgroundColor: Colors.grey[50]!,
        ),
      ],
    );
  }
}

// Widget de la section de selection de vehicule

class VehicleSelectionSection extends StatefulWidget {
  const VehicleSelectionSection({Key? key}) : super(key: key);

  @override
  State<VehicleSelectionSection> createState() =>
      _VehicleSelectionSectionState();
}

class _VehicleSelectionSectionState extends State<VehicleSelectionSection> {
  String? selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Véhicules',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _VehicleOption(
                image:
                    'https://cdn-icons-png.flaticon.com/512/2675/2675137.png',
                label: 'Camion frigorifique',
                isSelected: selectedVehicle == 'refrigerated',
                onTap: () => setState(() => selectedVehicle = 'refrigerated'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _VehicleOption(
                image:
                    'https://cdn-icons-png.flaticon.com/512/2675/2675242.png',
                label: 'Camion benne',
                isSelected: selectedVehicle == 'dump',
                onTap: () => setState(() => selectedVehicle = 'dump'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VehicleOption extends StatelessWidget {
  final String image;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleOption({
    Key? key,
    required this.image,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.grey[400]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Image.network(
              image,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de la section de selection de methode de paiement

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode de paiement',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined),
              const SizedBox(width: 12),
              const Text(
                'LivPay',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget de la section de selection de date

class DateTimeSelectionSection extends StatefulWidget {
  const DateTimeSelectionSection({super.key});

  @override
  State<DateTimeSelectionSection> createState() =>
      _DateTimeSelectionSectionState();
}

class _DateTimeSelectionSectionState extends State<DateTimeSelectionSection> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR').then((_) {
      setState(() {
        isInitialized = true;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    if (!isInitialized) {
      // Retourner un format simple si la localisation n'est pas encore initialisée
      return '${date.day}/${date.month}/${date.year}';
    }
    return DateFormat('dd MMMM yyyy', 'fr_FR').format(date);
  }

  void _onRequest() {
    // TODO: Implement API integration later
    showDialog(
      context: context,
      builder: (context) => SuccessDialog(
        title: 'Demande enregistrée avec succes !',
        message:
            'Votre demande de service a été programmé pour le ${_formatDate(selectedDate)} à ${selectedTime.format(context)} nous vous renverons un prestataire disponible.',
        buttonText: 'OK',
        onPressed: () {
          context.pushNamed(HomeScreen.name);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choississez la date et l\'heure',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3, // Donne plus d'espace à la date
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8), // Réduit le padding horizontal
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 20,
                            color: AppColors
                                .primary), // Réduit la taille de l'icône
                        const SizedBox(width: 4), // Réduit l'espacement
                        Flexible(
                          // Permet au texte de se réduire si nécessaire
                          child: Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14, // Réduit la taille du texte
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Ajoute des ... si le texte est trop long
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  width: 8), // Réduit l'espacement entre les éléments
              Expanded(
                flex:
                    2, // Donne moins d'espace à l'heure car elle est plus courte
                child: InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8), // Réduit le padding horizontal
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 20,
                            color: AppColors
                                .primary), // Réduit la taille de l'icône
                        const SizedBox(width: 4), // Réduit l'espacement
                        Flexible(
                          // Permet au texte de se réduire si nécessaire
                          child: Text(
                            selectedTime.format(context),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14, // Réduit la taille du texte
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Confirmer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
