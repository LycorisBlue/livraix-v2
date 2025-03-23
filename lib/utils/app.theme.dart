import 'package:flutter/material.dart';

class AppThemes {
  // Palette de couleurs vertes
  static final greenPalette = _GreenPalette();

  static final lightTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        headlineLarge:
            TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Gilroy', height: 1.2),
        headlineMedium: TextStyle(
          fontSize: 24,
          color: Color(0xFF32343E),
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          overflow: TextOverflow.fade,
          height: 1.1,
        ),
        headlineSmall:
            TextStyle(fontSize: 13, color: Color(0xFF32343E), fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyLarge:
            TextStyle(fontSize: 20, color: Color(0xFF32343E), fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodyMedium:
            TextStyle(fontSize: 16, color: Color(0xFF32343E), fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
        bodySmall:
            TextStyle(fontSize: 12, color: Color(0xFF32343E), fontFamily: 'Gilroy', overflow: TextOverflow.fade, height: 1.1),
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
          // Utilisation de la palette verte
          primary: greenPalette.normal,
          onPrimary: Colors.white, // Texte blanc sur fond vert
          secondary: greenPalette.lightHover,
          onSecondary: Color(0xFF32343E), // Texte foncé sur fond clair
          onPrimaryContainer: greenPalette.normalActive,
          error: const Color.fromARGB(255, 145, 18, 9),
          onError: const Color.fromARGB(124, 145, 18, 9),
          background: greenPalette.light.withOpacity(0.3),
          onBackground: Color(0xFF32343E),
          surface: greenPalette.light.withOpacity(0.2),
          onSurface: Color(0xFF32343E),
          onSurfaceVariant: greenPalette.light.withOpacity(0.25)),
      primaryColor: greenPalette.normal,
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      scaffoldBackgroundColor: greenPalette.light.withOpacity(0.1),
      useMaterial3: true,
      fontFamily: 'Gilroy',
      inputDecorationTheme: InputDecorationTheme(
        prefixStyle: const TextStyle(color: Color(0xFF32343E)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: greenPalette.normalActive)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // border: InputBorder.none,
        // hintStyle: const TextStyle(color: Co),
        labelStyle: const TextStyle(color: Color(0xFF32343E)),
        iconColor: const Color(0xFF32343E),
      ));

  static final darkTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
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
      ),
      colorScheme: ColorScheme(
          onPrimaryContainer: greenPalette.normalActive,
          brightness: Brightness.dark,
          primary: greenPalette.dark,
          onPrimary: Colors.white,
          secondary: greenPalette.darkHover,
          onSecondary: Colors.white.withOpacity(0.9),
          error: const Color.fromARGB(255, 145, 18, 9),
          onError: const Color.fromARGB(124, 145, 18, 9),
          background: greenPalette.darker,
          onBackground: Colors.white.withOpacity(0.8),
          surface: greenPalette.dark,
          onSurface: Colors.white,
          onSurfaceVariant: Colors.white.withOpacity(0.25)),
      primaryColor: greenPalette.dark,
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
        // border: InputBorder.none,
        labelStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.white,
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

// Classe pour encapsuler la palette de couleurs vertes
class _GreenPalette {
  // Light
  final Color light = const Color(0xFFE6EDE9); // #e6ede9 - rgb(230, 237, 233)
  final Color lightHover = const Color(0xFFDAE5DA); // #dae5da - rgb(218, 229, 218)
  final Color lightActive = const Color(0xFFB2C8BB); // #b2c8bb - rgb(178, 200, 187)

  // Normal
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

class AppCustomColors {
  // Couleurs utilitaires
  static const Color onSuccess = Color(0xFF05A70A); // Vert succès

  // Ajout des références à la palette verte pour un accès facile
  static _GreenPalette get green => AppThemes.greenPalette;

  // Ajout de méthodes utilitaires pour les états des boutons et autres éléments interactifs
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
}
