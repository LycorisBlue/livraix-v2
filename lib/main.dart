import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/utils/app.router.dart';
import 'package:livraix/utils/app.theme.dart';
import 'package:livraix/widgets/splash/widget.splash.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';

// Fonction pour tester la connexion avec différents protocoles
Future<void> testWebSocketConnection(String protocol, String host, String path, Map<String, dynamic> headers) async {
  final url = '$protocol$host$path';
  print('Test de connexion à $url...');

  try {
    final channel = IOWebSocketChannel.connect(Uri.parse(url), headers: headers);

    bool connected = false;

    channel.stream.listen(
      (message) {
        connected = true;
        print('✅ Connexion réussie à $url');
        print('Message reçu: $message');
      },
      onError: (error) {
        print('❌ Erreur avec $url: $error');
      },
      onDone: () {
        if (!connected) {
          print('⚠️ Connexion fermée sans recevoir de message: $url');
        } else {
          print('⚠️ Connexion fermée: $url');
        }
      },
    );

    // Envoyer un message de test
    channel.sink.add('{"type":"ping"}');

    // Attendre un peu pour voir la réponse
    await Future.delayed(Duration(seconds: 2));
  } catch (e) {
    print('❌ Échec de connexion à $url: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser SharedPreferences
  await GeneralManagerDB.initSharedPreferences();

  // Définir l'orientation de l'écran (portrait uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Information du serveur
  final host = 'api.livraix.com';
  final path = '/ws';
  final headers = {'username': 'test_user'};

  // Tester différents protocoles
  await testWebSocketConnection('ws://', host, path, headers);
  await testWebSocketConnection('wss://', host, path, headers);
  await testWebSocketConnection('http://', host, path, headers);
  await testWebSocketConnection('https://', host, path, headers);

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
