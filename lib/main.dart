import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/utils/app.router.dart';
import 'package:livraix/utils/app.theme.dart';
import 'package:livraix/widgets/splash/widget.splash.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

late StompClient stompClient;
void onConnect(StompFrame frame) {
  print('Connected');
  stompClient.subscribe(
    destination: '/user/gondomoisegm@gmail.com/queue/messages',
    callback: (frame) {
      print('Réception : ${frame.body}');
    },
  );

}

// Pour envoyer des messages

void sendMessage(message) {
    // Exemple d'objet de message à envoyer en paramètre de cette fonction
    // Inspire toi du code front_end aussi pour voir ce que j'ai fait là bas

    //Decliner offre

    // dynamic newMsg = {
    //     "id": '',
    //     "dateMessage": new Date().toISOString().slice(0, -1),
    //     "statut": 'DECLINE_T',
    //     "livraisonId": livraisonId,
    //     envoyeurId: idUser, // user connecté
    //     recepteurId: recepteurId, id de l'entreprise concernée
    //     contenu: "Déclinée", 
    //   };


    // Acepter offre

    // dynamic newMsg = {
    //     "id": '',
    //     "dateMessage": new Date().toISOString().slice(0, -1),
    //     "statut": 'ACCEPT_T',
    //     "livraisonId": livraisonId,
    //     envoyeurId: idUser, // user connecté
    //     recepteurId: recepteurId, //id de l'entreprise concernée
    //     contenu: offreFinale, // Le dernier montant de la conversation
    //   };

    // Simple offre

    // dynamic newMsg = {
    //   id: '',
    //   dateMessage: new Date().toISOString().slice(0, -1),
    //   statut: 'OFFER',
    //   livraisonId: livraisonId,
    //   envoyeurId: idUser, // user connecté,
    //   recepteurId: recepteurId, //id de l'entreprise concernée
    //   contenu: messageText, // montant à envoyer pour l'offre
    // };

    try {
      if (stompClient.connected) {
        stompClient.send(
          destination: '/app/sendMessage',
          body: json.encode(message),
        );

      }
    }catch (error) {
      print('🚫 WebSocket non connecté. $error');
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


  stompClient = StompClient(
    config: StompConfig(
      url: 'ws://192.168.2.1:9090/ws/websocket',
      onConnect: onConnect,
      onWebSocketError: (dynamic error) => print(error.toString()),
      stompConnectHeaders: {
        'username': "gondomoisegm@gmail.com", // Faut changer avec l'email du transporteur qui est connecté
      },
    ),
  );

  stompClient.activate();
  // Tester différents protocoles

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
