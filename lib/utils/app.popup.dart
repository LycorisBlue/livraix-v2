import 'package:flutter/material.dart';
import 'package:livraix/widgets/widgets.dart'; // Assumes this contains AppColors, AppTextStyles, etc.

class AppPopup {
  /// Affiche une boîte de dialogue personnalisée avec une icône, un titre, un contenu et des actions.
  static Future<void> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    Color iconColor = AppColors.primary, // Couleur par défaut tirée de ton design system
    String closeButtonText = 'Fermer', // Texte par défaut pour le bouton de fermeture
    String? actionButtonText, // Texte optionnel pour une action supplémentaire
    VoidCallback? onActionPressed, // Callback optionnel pour l'action supplémentaire
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Permet de fermer en cliquant à l'extérieur
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Taille minimale pour éviter d'occuper tout l'écran
              children: [
                // Icône
                Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
                const SizedBox(height: 16),
                // Titre
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.text,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Contenu
                Text(
                  content,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Boutons d'action
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton de fermeture (toujours présent)
                    Expanded(
                      child: CustomButton(
                        text: closeButtonText,
                        color: Colors.white,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        onPressed: () {
                          Navigator.of(context).pop(); // Ferme la popup
                        },
                      ),
                    ),
                    // Bouton d'action supplémentaire (optionnel)
                    if (actionButtonText != null && onActionPressed != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: actionButtonText,
                          color: AppColors.primary,
                          textColor: AppColors.textOnPrimary,
                          onPressed: () {
                            onActionPressed(); // Exécute l'action
                            Navigator.of(context).pop(); // Ferme la popup après l'action
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Exemple d'utilisation dans un autre widget
/*
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AppPopup.show(
              context: context,
              icon: Icons.info,
              title: 'Confirmation',
              content: 'Voulez-vous vraiment effectuer cette action ?',
              closeButtonText: 'Annuler',
              actionButtonText: 'Confirmer',
              onActionPressed: () {
                print('Action confirmée !');
              },
            );
          },
          child: const Text('Ouvrir Popup'),
        ),
      ),
    );
  }
}
*/
