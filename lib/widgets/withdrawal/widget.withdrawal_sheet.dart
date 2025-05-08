import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/models/user_cnx_details.dart';
import 'package:livraix/repository/balance.service.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.withdrawal_sheet.dart';

/// Widget principal pour le bottomsheet de retrait d'argent
class WithdrawalBottomSheet {
  /// Méthode statique pour afficher le bottomsheet de retrait
  static Future<void> show(
    BuildContext context, {
    required double currentBalance,
    required Function() onSuccess,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WithdrawalSheet(
        currentBalance: currentBalance,
        onSuccess: onSuccess,
      ),
    );
  }
}

/// Widget pour afficher un champ de montant avec une validation
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final String? hintText;
  final Function(String)? onChanged;

  const AmountField({
    Key? key,
    required this.controller,
    required this.label,
    this.errorText,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: hintText ?? 'Ex: 5000',
            suffixText: 'XOF',
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Widget pour afficher les détails d'un frais
class FeeDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const FeeDetailItem({
    Key? key,
    required this.label,
    required this.value,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.primary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher l'en-tête du bottomsheet
class SheetHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SheetHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de poignée
        Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// Widget pour afficher les détails actuels de l'utilisateur
class UserBalanceInfo extends StatelessWidget {
  final String userName;
  final double balance;

  const UserBalanceInfo({
    Key? key,
    required this.userName,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Solde disponible: ${balance.toStringAsFixed(0)} XOF',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour le sélecteur de prestataire de service
class ServiceProviderSelector extends StatelessWidget {
  final String selectedProvider;
  final Function(String) onChanged;

  const ServiceProviderSelector({
    Key? key,
    required this.selectedProvider,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prestataire de service',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedProvider,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'ORANGE',
                child: Text('Orange Money'),
              ),
              DropdownMenuItem(
                value: 'MTN',
                child: Text('MTN Mobile Money'),
              ),
              DropdownMenuItem(
                value: 'MOOV',
                child: Text('Moov Money'),
              ),
              DropdownMenuItem(
                value: 'WAVE',
                child: Text('Wave'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
