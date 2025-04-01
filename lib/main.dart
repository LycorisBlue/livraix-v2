import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/utils/app.router.dart';
import 'package:livraix/utils/app.theme.dart';
import 'package:livraix/widgets/splash/widget.splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser SharedPreferences
  await GeneralManagerDB.initSharedPreferences();

  // Définir l'orientation de l'écran (portrait uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Créer le router en commençant par le splash screen
    final appRouter = AppRouter(initialRoute: SplashScreen.path);

    return Builder(
      builder: (context) => MaterialApp.router(
        title: 'LIVRAIX',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        builder: AppThemes.buildWrapper,
        routerConfig: appRouter.router,
      ),
    );
  }
}
