import 'package:flutter/material.dart';

class AppThemes {
  // Palettes de couleurs
  static final greenPalette = _GreenPalette();
  static final neutralPalette = _NeutralPalette();
  static final accentPalette = _AccentPalette();

  static final lightTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineLarge:
            TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Gilroy', height: 1.2),
        headlineMedium: TextStyle(
          fontSize: 24,
          color: neutralPalette.darkText,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          overflow: TextOverflow.fade,
          height: 1.1,
        ),
        headlineSmall: TextStyle(
            fontSize: 13, color: neutralPalette.darkText, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyLarge: TextStyle(
            fontSize: 20, color: neutralPalette.darkText, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyMedium: TextStyle(
            fontSize: 16, color: neutralPalette.darkText, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodySmall: TextStyle(
            fontSize: 12, color: neutralPalette.darkText, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        displayMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          overflow: TextOverflow.fade,
          height: 1.1,
        ),
        displaySmall:
            TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        displayLarge:
            TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        titleMedium: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        titleSmall: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
      ),
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: greenPalette.normal,
          onPrimary: Colors.white,
          secondary: accentPalette.normal,
          onSecondary: Colors.white,
          tertiary: accentPalette.accent,
          onTertiary: Colors.white,
          onPrimaryContainer: greenPalette.normalActive,
          error: accentPalette.error,
          onError: Colors.white,
          errorContainer: accentPalette.errorLight,
          onErrorContainer: accentPalette.errorDark,
          background: greenPalette.light.withOpacity(0.2),
          onBackground: neutralPalette.darkText,
          surface: Colors.white,
          onSurface: neutralPalette.darkText,
          surfaceVariant: neutralPalette.lightGrey,
          onSurfaceVariant: neutralPalette.mediumGrey,
          outline: neutralPalette.mediumGrey),
      primaryColor: greenPalette.normal,
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      scaffoldBackgroundColor: greenPalette.light.withOpacity(0.2),
      useMaterial3: true,
      fontFamily: 'Gilroy',
      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: TextStyle(color: neutralPalette.darkText),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: greenPalette.normalActive)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelStyle: TextStyle(color: neutralPalette.darkText),
        iconColor: neutralPalette.darkText,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: greenPalette.normal,
        disabledColor: neutralPalette.lightGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ));

  static final darkTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineLarge:
            TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Gilroy', height: 1.2),
        headlineMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          overflow: TextOverflow.fade,
          height: 1.1,
        ),
        headlineSmall:
            TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyLarge: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        displayMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          overflow: TextOverflow.fade,
          height: 1.1,
        ),
        displaySmall:
            TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        displayLarge:
            TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        titleMedium: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        titleSmall: TextStyle(fontSize: 12, color: Colors.white, fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
      ),
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: greenPalette.normal,
          onPrimary: Colors.white,
          secondary: accentPalette.dark,
          onSecondary: Colors.white,
          tertiary: accentPalette.accentDark,
          onTertiary: Colors.white,
          onPrimaryContainer: greenPalette.normalActive,
          error: accentPalette.errorDark,
          onError: Colors.white,
          errorContainer: accentPalette.error.withOpacity(0.7),
          onErrorContainer: Colors.white,
          background: greenPalette.darker,
          onBackground: Colors.white.withOpacity(0.9),
          surface: greenPalette.dark,
          onSurface: Colors.white,
          surfaceVariant: greenPalette.darkHover,
          onSurfaceVariant: Colors.white.withOpacity(0.8),
          outline: neutralPalette.lightGrey),
      primaryColor: greenPalette.normal,
      scaffoldBackgroundColor: greenPalette.darker,
      cardColor: greenPalette.dark,
      dialogBackgroundColor: greenPalette.dark,
      useMaterial3: true,
      fontFamily: 'Gilroy',
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: greenPalette.lightActive)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: greenPalette.normal,
        disabledColor: greenPalette.darkHover.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ));

  static Widget buildWrapper(BuildContext context, Widget? child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(0.9),
      ),
      child: child!,
    );
  }
}

// Classe pour encapsuler la palette de couleurs vertes (principale)
class _GreenPalette {
  // Light
  final Color light = const Color(0xFFE6EDE9); // #e6ede9 - rgb(230, 237, 233)
  final Color lightHover = const Color(0xFFDAE5DA); // #dae5da - rgb(218, 229, 218)
  final Color lightActive = const Color(0xFFB2C8BB); // #b2c8bb - rgb(178, 200, 187)

  // Normal - Couleur principale de la marque
  final Color normal = const Color(0xFF074F24); // #074f24 - rgb(7, 79, 36)
  final Color normalHover = const Color(0xFF06472D); // #06472d - rgb(6, 71, 45)
  final Color normalActive = const Color(0xFF063F1D); // #063f1d - rgb(6, 63, 29)

  // Dark
  final Color dark = const Color(0xFF053B1B); // #053b1b - rgb(5, 59, 27)
  final Color darkHover = const Color(0xFF042F16); // #042f16 - rgb(4, 47, 22)
  final Color darkActive = const Color(0xFF03241B); // #03241b - rgb(3, 36, 27)

  // Darker
  final Color darker = const Color(0xFF021C0D); // #021c0d - rgb(2, 28, 13)
}

// Nouvelle classe pour les couleurs neutres
class _NeutralPalette {
  // Texte
  final Color darkText = const Color(0xFF32343E); // Texte principal
  final Color mediumText = const Color(0xFF666870); // Texte secondaire
  final Color lightText = const Color(0xFF9A9CA6); // Texte tertiaire

  // Gris
  final Color lightGrey = const Color(0xFFF1F1F5); // Fond clair, bordures légères
  final Color mediumGrey = const Color(0xFFDCDDE1); // Bordures, séparateurs
  final Color darkGrey = const Color(0xFFACADB4); // États désactivés
}

// Nouvelle classe pour les couleurs d'accentuation et fonctionnelles
class _AccentPalette {
  // Couleur d'accentuation secondaire
  final Color normal = const Color(0xFF1E88E5); // Bleu - utilisation secondaire
  final Color dark = const Color(0xFF1565C0); // Version foncée pour le thème sombre

  // Couleur d'accentuation tertiaire
  final Color accent = const Color(0xFFF57C00); // Orange - accents, mises en évidence
  final Color accentDark = const Color(0xFFEF6C00); // Version foncée pour le thème sombre

  // Succès
  final Color success = const Color(0xFF05A70A); // Vert succès
  final Color successLight = const Color(0xFFD4EDDA); // Fond pour messages de succès
  final Color successDark = const Color(0xFF04870A); // Version foncée

  // Erreur
  final Color error = const Color(0xFFE53935); // Rouge erreur plus vif
  final Color errorLight = const Color(0xFFFDECEA); // Fond pour messages d'erreur
  final Color errorDark = const Color(0xFFC62828); // Version foncée pour le thème sombre

  // Avertissement
  final Color warning = const Color(0xFFFFC107); // Jaune avertissement
  final Color warningLight = const Color(0xFFFFF8E1); // Fond pour messages d'avertissement
  final Color warningDark = const Color(0xFFFFB300); // Version foncée

  // Information
  final Color info = const Color(0xFF2196F3); // Bleu information
  final Color infoLight = const Color(0xFFE3F2FD); // Fond pour messages d'information
  final Color infoDark = const Color(0xFF1976D2); // Version foncée
}

class AppCustomColors {
  // Accès facile aux palettes
  static _GreenPalette get green => AppThemes.greenPalette;
  static _NeutralPalette get neutral => AppThemes.neutralPalette;
  static _AccentPalette get accent => AppThemes.accentPalette;

  // Méthodes utilitaires pour les états des boutons
  static Color buttonColor(bool isHovered, bool isPressed) {
    if (isPressed) return green.normalActive;
    if (isHovered) return green.normalHover;
    return green.normal;
  }

  static Color darkButtonColor(bool isHovered, bool isPressed) {
    if (isPressed) return green.darkActive;
    if (isHovered) return green.darkHover;
    return green.dark;
  }

  static Color lightBackgroundColor(bool isHovered, bool isPressed) {
    if (isPressed) return green.lightActive;
    if (isHovered) return green.lightHover;
    return green.light;
  }

  // Nouvelles méthodes utilitaires
  static Color secondaryButtonColor(bool isHovered, bool isPressed) {
    if (isPressed) return accent.dark;
    if (isHovered) return accent.normal.withOpacity(0.8);
    return accent.normal;
  }

  // Opacités standards pour maintenir la cohérence
  static double get backgroundOpacity => 0.2;
  static double get overlayOpacity => 0.8;
  static double get disabledOpacity => 0.5;
  static double get hoverOpacity => 0.9;

  // États de messages
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return accent.success;
      case 'error':
        return accent.error;
      case 'warning':
        return accent.warning;
      case 'info':
        return accent.info;
      default:
        return green.normal;
    }
  }

  // Arrière-plans légers pour les messages
  static Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return accent.successLight;
      case 'error':
        return accent.errorLight;
      case 'warning':
        return accent.warningLight;
      case 'info':
        return accent.infoLight;
      default:
        return green.light.withOpacity(backgroundOpacity);
    }
  }
}
