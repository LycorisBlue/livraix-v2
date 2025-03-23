import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livraix/widgets/authentication/login/widget.login.dart';
import 'package:livraix/widgets/authentication/signup/widget.signup.dart';
import 'package:livraix/widgets/contrat/widget.contract_details.dart';
import 'package:livraix/widgets/home/widget.home.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.welcome.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
          elevation: borderColor != null ? 0 : 1,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
