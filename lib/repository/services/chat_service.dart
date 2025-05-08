import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/models/user_cnx_details.dart';

/// Service qui gère la connexion WebSocket et les communications via STOMP
class ChatService {
  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();

  // Client STOMP
  StompClient? _stompClient;

  // État de la connexion
  bool _isConnected = false;

  // Callbacks
  final List<Function(dynamic)> _messageCallbacks = [];
  final List<Function()> _connectionCallbacks = [];
  final List<Function(String)> _errorCallbacks = [];

  // URL du serveur WebSocket
  final String _serverUrl = 'ws://api.livraix.com:9090/ws/websocket';

  /// Initialise et active la connexion STOMP
  Future<bool> initialize() async {
    try {
      // Récupérer les informations utilisateur
      final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();

      if (userDetails == null) {
        _notifyError('Aucun utilisateur connecté');
        return false;
      }

      // Créer le client STOMP
      _stompClient = StompClient(
        config: StompConfig(
          url: _serverUrl,
          onConnect: _onConnect,
          onWebSocketError: _onWebSocketError,
          stompConnectHeaders: {
            'username': userDetails.email,
          },
          webSocketConnectHeaders: {
            'username': userDetails.email,
          },
        ),
      );

      // Activer la connexion
      _stompClient?.activate();

      return true;
    } catch (e) {
      _notifyError('Erreur lors de l\'initialisation: $e');
      return false;
    }
  }

  /// Méthode appelée lorsque la connexion STOMP est établie
  void _onConnect(StompFrame frame) {
    _isConnected = true;

    // Récupérer l'email de l'utilisateur pour s'abonner à sa file d'attente
    GeneralManagerDB.getUserDetails().then((userDetails) {
      if (userDetails != null) {
        // S'abonner à la file d'attente de l'utilisateur
        _stompClient?.subscribe(
          destination: '/user/${userDetails.email}/queue/messages',
          callback: _onMessageReceived,
        );

        // S'abonner aux notifications générales
        _stompClient?.subscribe(
          destination: '/topic/notifications',
          callback: _onMessageReceived,
        );

        // Notifier les callbacks de connexion
        _notifyConnection();

        debugPrint('🟢 WebSocket connecté');
      }
    });
  }

  /// Envoie un message texte simple
  Future<bool> sendTextMessage(String livraisonId, String recepteurId, String text) async {
    final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();

    if (userDetails == null) {
      _notifyError('Aucun utilisateur connecté');
      return false;
    }

    final Map<String, dynamic> message = {
      "id": '',
      "dateMessage": DateTime.now().toIso8601String().split('.').first,
      "statut": 'TEXT', // Utilisez le statut 'TEXT' pour les messages texte
      "livraisonId": livraisonId,
      "envoyeurId": userDetails.id, // id de l'utilisateur connecté
      "recepteurId": recepteurId, // id du destinataire
      "contenu": text, // Le contenu du message texte
    };

    return sendMessage(message);
  }

  /// Méthode appelée lorsqu'une erreur WebSocket survient
  void _onWebSocketError(dynamic error) {
    _isConnected = false;
    _notifyError('Erreur WebSocket: $error');
    debugPrint('🔴 WebSocket erreur: $error');

    // Tentative de reconnexion après un délai
    Future.delayed(const Duration(seconds: 5), () {
      if (_stompClient != null && !_isConnected) {
        debugPrint('🔄 Tentative de reconnexion WebSocket...');
        _stompClient?.activate();
      }
    });
  }

  /// Méthode appelée lorsqu'un message est reçu
  void _onMessageReceived(dynamic frame) {
    try {
      if (frame.body != null) {
        final dynamic message = json.decode(frame.body!);
        _notifyMessage(message);
        debugPrint('📨 Message reçu: ${(json.decode(message))["contenu"]}');
      }
    } catch (e) {
      _notifyError('Erreur lors de la réception du message: $e');
      debugPrint('🔴 Erreur de parsing du message: $e');
    }
  }

  /// Envoie un message au serveur
  Future<bool> sendMessage(Map<String, dynamic> message) async {
    try {
      if (!_isConnected || _stompClient == null) {
        _notifyError('WebSocket non connecté');
        return false;
      }

      _stompClient!.send(
        destination: '/app/sendMessage',
        body: json.encode(message),
      );

      debugPrint('📤 Message envoyé: $message');
      return true;
    } catch (e) {
      _notifyError('Erreur lors de l\'envoi du message: $e');
      return false;
    }
  }

  /// Envoie un message d'acceptation d'offre
  /// Note: Ceci ne crée pas de conversation, juste un message d'acceptation
  Future<bool> sendAcceptOffer(String livraisonId, String recepteurId, String offreFinale) async {
    final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();

    if (userDetails == null) {
      _notifyError('Aucun utilisateur connecté');
      return false;
    }

    final Map<String, dynamic> message = {
      "id": '',
      "dateMessage": DateTime.now().toIso8601String().split('.').first,
      "statut": 'ACCEPT_T',
      "livraisonId": livraisonId,
      "envoyeurId": userDetails.id, // id de l'utilisateur connecté
      "recepteurId": recepteurId, // id de l'entreprise concernée
      "contenu": offreFinale, // Le dernier montant de la conversation
    };

    return sendMessage(message);
  }

  /// Envoie un message de déclinaison d'offre
  /// Note: Ceci ne crée pas de conversation, juste un message de refus
  Future<bool> sendDeclineOffer(String livraisonId, String recepteurId) async {
    final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();

    if (userDetails == null) {
      _notifyError('Aucun utilisateur connecté');
      return false;
    }

    final Map<String, dynamic> message = {
      "id": '',
      "dateMessage": DateTime.now().toIso8601String().split('.').first,
      "statut": 'DECLINE_T',
      "livraisonId": livraisonId,
      "envoyeurId": userDetails.id, // id de l'utilisateur connecté
      "recepteurId": recepteurId, // id de l'entreprise concernée
      "contenu": "Déclinée",
    };

    return sendMessage(message);
  }

  /// Envoie une simple offre
  Future<bool> sendSimpleOffer(String livraisonId, String recepteurId, String montant) async {
    final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();

    if (userDetails == null) {
      _notifyError('Aucun utilisateur connecté');
      return false;
    }

    final Map<String, dynamic> message = {
      "id": '',
      "dateMessage": DateTime.now().toIso8601String().split('.').first,
      "statut": 'OFFER',
      "livraisonId": livraisonId,
      "envoyeurId": userDetails.id, // id de l'utilisateur connecté
      "recepteurId": recepteurId, // id de l'entreprise concernée
      "contenu": montant, // montant à envoyer pour l'offre
    };

    return sendMessage(message);
  }

  /// Déconnecte le client STOMP
  void disconnect() {
    try {
      if (_stompClient != null && _isConnected) {
        _stompClient!.deactivate();
        _isConnected = false;
        debugPrint('🔵 WebSocket déconnecté');
      }
    } catch (e) {
      _notifyError('Erreur lors de la déconnexion: $e');
    }
  }

  /// Notifie tous les callbacks de message
  void _notifyMessage(dynamic message) {
    for (final callback in _messageCallbacks) {
      // à voir
      callback(json.decode(message));
    }
  }

  /// Notifie tous les callbacks de connexion
  void _notifyConnection() {
    for (final callback in _connectionCallbacks) {
      callback();
    }
  }

  /// Notifie tous les callbacks d'erreur
  void _notifyError(String error) {
    for (final callback in _errorCallbacks) {
      callback(error);
    }
    debugPrint('🔴 Error in ChatService: $error');
  }

  /// Ajoute un callback pour les messages reçus
  void addMessageCallback(Function(dynamic) callback) {
    _messageCallbacks.add(callback);
  }

  /// Supprime un callback pour les messages reçus
  void removeMessageCallback(Function(dynamic) callback) {
    _messageCallbacks.remove(callback);
  }

  /// Ajoute un callback pour les événements de connexion
  void addConnectionCallback(Function() callback) {
    _connectionCallbacks.add(callback);
  }

  /// Supprime un callback pour les événements de connexion
  void removeConnectionCallback(Function() callback) {
    _connectionCallbacks.remove(callback);
  }

  /// Ajoute un callback pour les erreurs
  void addErrorCallback(Function(String) callback) {
    _errorCallbacks.add(callback);
  }

  /// Supprime un callback pour les erreurs
  void removeErrorCallback(Function(String) callback) {
    _errorCallbacks.remove(callback);
  }

  /// Retourne l'état actuel de la connexion
  bool get isConnected => _isConnected;
}
