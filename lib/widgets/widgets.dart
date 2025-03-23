import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:livraix/utils/app.popup.dart';
import 'package:livraix/widgets/history/widget.history.dart';
import 'package:livraix/widgets/welcome/widget.welcome.dart';
import 'package:url_launcher/url_launcher.dart';

// Palette de couleurs vertes
class GreenPalette {
  // Light
  static const Color light = Color.fromARGB(255, 36, 72, 52); // #e6ede9 - rgb(230, 237, 233)
  static const Color lightHover = Color(0xFFDAE5DA); // #dae5da - rgb(218, 229, 218)
  static const Color lightActive = Color(0xFFB2C8BB); // #b2c8bb - rgb(178, 200, 187)

  // Normal
  static const Color normal = Color(0xFF074F24); // #074f24 - rgb(7, 79, 36)
  static const Color normalHover = Color(0xFF06472D); // #06472d - rgb(6, 71, 45)
  static const Color normalActive = Color(0xFF063F1D); // #063f1d - rgb(6, 63, 29)

  // Dark
  static const Color dark = Color(0xFF053B1B); // #053b1b - rgb(5, 59, 27)
  static const Color darkHover = Color(0xFF042F16); // #042f16 - rgb(4, 47, 22)
  static const Color darkActive = Color(0xFF03241B); // #03241b - rgb(3, 36, 27)

  // Darker
  static const Color darker = Color(0xFF021C0D); // #021c0d - rgb(2, 28, 13)
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
    height: 1.5,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
  );
}

class AppColors {
  // Remplacer la couleur primaire par le vert normal
  static const Color primary = GreenPalette.normal;
  static const Color primaryHover = GreenPalette.normalHover;
  static const Color primaryActive = GreenPalette.normalActive;

  // Garder le fond blanc
  static const Color background = Colors.white;
  static const Color backgroundLight = GreenPalette.light;

  // Couleurs de texte
  static const Color text = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;

  // Couleurs sémantiques
  static const Color success = Color(0xFF05A70A);
  static const Color accent = GreenPalette.lightActive;
}

//Header Commun a l'ecran de connexion et d'inscription

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyles.subtitle.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

//Widget de champs de texte

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color backgroundColor;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.backgroundColor = Colors.white,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GreenPalette.normalActive),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GreenPalette.normalActive),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


class DeliveryDetailsBottomSheet extends StatelessWidget {
  final String title;
  final String id;
  final String route;
  final String distance;
  final String duration;
  final String date;
  final String weight;
  final VoidCallback? onDecline;
  final VoidCallback? onAccept;
  // Coordonnées pour la navigation
  final LatLng originCoords;
  final LatLng destinationCoords;

  const DeliveryDetailsBottomSheet({
    Key? key,
    required this.title,
    required this.id,
    required this.route,
    required this.distance,
    required this.duration,
    required this.date,
    required this.weight,
    this.onDecline,
    this.onAccept,
    required this.originCoords,
    required this.destinationCoords,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String title,
    required String id,
    required String route,
    required String distance,
    required String duration,
    required String date,
    required String weight,
    VoidCallback? onDecline,
    VoidCallback? onAccept,
    LatLng originCoords = const LatLng(5.301, -4.010), // Treichville par défaut
    LatLng destinationCoords = const LatLng(5.326, -4.362), // Dabou par défaut
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeliveryDetailsBottomSheet(
        title: title,
        id: id,
        route: route,
        distance: distance,
        duration: duration,
        date: date,
        weight: weight,
        onDecline: onDecline,
        onAccept: onAccept,
        originCoords: originCoords,
        destinationCoords: destinationCoords,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header avec la carte et position
        _buildMapHeader(context),

        // Contenu des détails de la livraison
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Informations sur la route
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF074F24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$distance · $duration',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                ),

                // Détails de la livraison
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Colis ID: $id',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF074F24).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              date,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF074F24),
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Pickup · $weight',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Boutons d'action
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Fermer',
                          color: Colors.white,
                          textColor: Colors.red.shade700,
                          borderColor: Colors.red.shade700,
                          onPressed: () {
                            Navigator.pop(context);
                            if (onDecline != null) onDecline!();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
Expanded(
                        child: CustomButton(
                          text: 'Prendre en charge',
                          color: const Color(0xFF074F24),
                          textColor: Colors.white,
                          onPressed: () {
                            // Afficher le popup de confirmation
                            AppPopup.show(
                              context: context,
                              icon: Icons.check_circle,
                              title: 'Confirmer la prise en charge',
                              content: 'Une fois validé, le client recevra votre disponibilité pour cette livraison.',
                              closeButtonText: 'Annuler',
                              actionButtonText: 'Valider',
                              onActionPressed: () {
                                // Action exécutée après confirmation
                                if (onAccept != null) onAccept!(); // Appelle le callback onAccept si fourni
                                Navigator.pop(context); // Ferme la BottomSheet
                                context.pushNamed(HistoryScreen.name); // Redirige vers HistoryScreen
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapHeader(BuildContext context) {
    return Stack(
      children: [
        // Carte
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          child: _buildMap(context),
        ),

        // Filigrane "Afficher l'itinéraire"
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _launchMapDirections(),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Voir l'itinéraire",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bouton retour
        Positioned(
          top: 80,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Méthode pour ouvrir l'application de cartographie avec l'itinéraire


Future<void> _launchMapDirections() async {
    // Valider les coordonnées de destination
    if (destinationCoords == null) {
      print('Coordonnées invalides');
      return;
    }

    try {
      if (Platform.isAndroid) {
        // Pour Android, essayer d'ouvrir Google Maps avec le schéma google.navigation
        final mapUri = Uri.parse(
          'google.navigation:q=${destinationCoords.latitude},${destinationCoords.longitude}',
        );

        if (await canLaunchUrl(mapUri)) {
          await launchUrl(mapUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      // Fallback vers une URL web pour toutes les plateformes
      final String url = Platform.isIOS
          ? 'https://maps.apple.com/?daddr=${destinationCoords.latitude},${destinationCoords.longitude}&dirflg=d'
          : 'https://www.google.com/maps/dir/?api=1&destination=${destinationCoords.latitude},${destinationCoords.longitude}';

      final webUri = Uri.parse(url);

      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Impossible d\'ouvrir l\'application de navigation');
      }
    } catch (e) {
      print('Erreur lors de l\'ouverture de la navigation : $e');
    }
  }


  Widget _buildMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: destinationCoords, // Centre la carte sur la destination
        initialZoom: 11.0,
        onTap: (tapPosition, point) => _launchMapDirections(), // Garde la possibilité d'ouvrir l'itinéraire
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.livraix.app',
        ),
        MarkerLayer(
          markers: [
            // Marqueur uniquement pour la destination
            Marker(
              point: destinationCoords,
              width: 40,
              height: 40,
              child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
            ),
            Marker(
              point: originCoords,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 40,
              ),
            ),
          ],
        ),
        // Suppression de la PolylineLayer pour ne pas afficher l'itinéraire
      ],
    );
  }
}


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
