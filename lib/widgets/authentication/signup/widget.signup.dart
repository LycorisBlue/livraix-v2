import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livraix/repository/auth.service.dart';
import 'package:livraix/widgets/authentication/login/widget.login.dart';
import 'package:livraix/widgets/email_verification/widget.email_verification.dart';
import 'package:livraix/widgets/widgets.dart';

import '../forgot_password/widget.forgot_password.dart';
// Importer le service d'authentification

part 'screen.signup.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const CustomRadioButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF074F24) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF074F24),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// SignupScreen reste dans screen.signup.dart
