import 'dart:async';
import 'dart:convert';
import 'dart:math' as Math;
import 'package:flutter/foundation.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/models/chat/models.conversation.dart';
import 'package:livraix/models/chat/models.conversation_message.dart';
import 'package:livraix/models/user_cnx_details.dart';
import 'package:livraix/repository/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestionnaire global pour les WebSockets et les conversations
class WebSocketManager {
  // Singleton pattern
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  // Service de chat
  final ChatService _chatService = ChatService();

  // Liste des conversations
  final List<Conversation> _conversations = [];

  // Stream controller pour notifier les changements de conversations
  final StreamController<List<Conversation>> _conversationsController = StreamController<List<Conversation>>.broadcast();

  // Stream controller pour notifier les erreurs
  final StreamController<String> _errorController = StreamController<String>.broadcast();

  // Stream controller pour notifier les changements de statut de connexion
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  // Clé pour le stockage local des conversations
  static const String _conversationsStorageKey = 'livraix_conversations';

  /// Initialise le gestionnaire et établit la connexion WebSocket
  Future<bool> initialize() async {
    try {
      // Charger les conversations depuis le stockage local
      await _loadConversationsFromStorage();

      // Configurer les callbacks
      _chatService.addMessageCallback(_handleIncomingMessage);
      _chatService.addConnectionCallback(_handleConnection);
      _chatService.addErrorCallback(_handleError);

      // Initialiser le service de chat
      final bool initialized = await _chatService.initialize();

      _connectionStatusController.add(initialized);
      return initialized;
    } catch (e) {
      _handleError('Erreur lors de l\'initialisation du WebSocketManager: $e');
      return false;
    }
  }

Future<bool> createLocalConversationAndSendOffer(
      String livraisonId, String entrepriseId, String entrepriseName, String content) async {
    try {
      // Vérifier si une conversation existe déjà pour cette livraison
      final existingConversation = _findConversationByDeliveryId(livraisonId);

      if (existingConversation != null && !existingConversation.isComplete) {
        // Si une conversation active existe déjà, ajouter le message d'offre à celle-ci
        return await createLocalConversationAndSendMessage(livraisonId, entrepriseId, content, MessageType.offer,
            receiverName: entrepriseName);
      }

      // Générer un message temporaire
      final userDetails = await GeneralManagerDB.getUserDetails();
      if (userDetails == null) return false;

      final message = ConversationMessage(
        id: null, // Sera attribué par le serveur
        timestamp: DateTime.now(),
        content: content,
        type: MessageType.offer,
        senderUserId: userDetails.id,
        receiverUserId: entrepriseId,
        deliveryId: livraisonId,
        isSentByMe: true,
      );

      // Créer une conversation locale
      final newConversation = Conversation.createWithInitialMessage(
        id: livraisonId,
        title: entrepriseName,
        deliveryId: livraisonId,
        companyId: entrepriseId,
        initialMessage: message,
        isComplete: false, // S'assurer que la conversation est active
      );

      // Ajouter à la liste des conversations locales
      _conversations.add(newConversation);
      _notifyConversationsChanged();

      // Sauvegarder en local
      _saveConversationsToStorage();

      // Envoyer le message au serveur
      return await sendSimpleOffer(livraisonId, entrepriseId, content);
    } catch (e) {
      _handleError('Erreur lors de la création de la conversation locale: $e');
      return false;
    }
  }

  /// Envoie un message texte
  Future<bool> sendTextMessage(String deliveryId, String receiverId, String text) async {
    final result = await _chatService.sendTextMessage(deliveryId, receiverId, text);

    if (result) {
      // Le message sera ajouté à la conversation lorsqu'il sera reçu via le WebSocket
      debugPrint('📤 Message texte envoyé avec succès');
    }

    return result;
  }

  Future<bool> createLocalConversationAndSendMessage(String deliveryId, String receiverId, String content, MessageType type,
      {String? receiverName}) async {
    try {
      final UserDetails? userDetails = await GeneralManagerDB.getUserDetails();
      if (userDetails == null) return false;

      // Créer un message temporaire
      final message = ConversationMessage(
        id: null,
        timestamp: DateTime.now(),
        content: content,
        type: type,
        senderUserId: userDetails.id,
        receiverUserId: receiverId,
        deliveryId: deliveryId,
        isSentByMe: true,
      );

      bool success = false;

      // Gérer le cas selon le type de message
      switch (type) {
        case MessageType.offer:
          // Pour une offre, créer ou mettre à jour la conversation
          final existingConversation = _findConversationByDeliveryId(deliveryId);

          if (existingConversation != null) {
            // Ajouter à une conversation existante
            final updatedConversation = existingConversation.addMessage(message);
            _updateConversation(updatedConversation);
            debugPrint('✅ Message d\'offre ajouté localement à la conversation existante');
          } else {
            // Créer une nouvelle conversation
            final newConversation = Conversation.createWithInitialMessage(
              id: deliveryId,
              title: receiverName ?? "Conversation #${deliveryId.substring(0, Math.min(deliveryId.length, 4))}",
              deliveryId: deliveryId,
              companyId: receiverId,
              initialMessage: message,
            );
            _conversations.add(newConversation);
            debugPrint('✅ Nouvelle conversation créée localement pour une offre');
          }

          // Notifier les auditeurs et sauvegarder
          _notifyConversationsChanged();
          _saveConversationsToStorage();

          // Envoyer l'offre au serveur
          success = await sendSimpleOffer(deliveryId, receiverId, content);
          break;

        case MessageType.acceptOffer:
          // Pour une acceptation, juste envoyer le message sans créer de conversation
          success = await sendAcceptOffer(deliveryId, receiverId, content);

          // Si une conversation existante existe, la marquer comme terminée
          await closeConversationAfterDecision(deliveryId);
          break;

        case MessageType.declineOffer:
          // Pour un refus, juste envoyer le message sans créer de conversation
          success = await sendDeclineOffer(deliveryId, receiverId);

          // Si une conversation existante existe, la marquer comme terminée
          await closeConversationAfterDecision(deliveryId);
          break;
      }

      return success;
    } catch (e) {
      _handleError('Erreur lors de la création locale du message: $e');
      return false;
    }
  }

  /// Gère les messages entrants
  void _handleIncomingMessage(dynamic messageData) {
    try {
      // Récupérer l'ID utilisateur actuel
      GeneralManagerDB.getUserDetails().then((userDetails) {
        if (userDetails == null) return;

        final currentUserId = userDetails.id ?? '';

        // Créer un objet message à partir des données
        final message = ConversationMessage.fromJson(messageData, currentUserId);

        // Identifier la conversation associée (basée sur l'ID de livraison)
        final deliveryId = message.deliveryId;
        if (deliveryId == null) return;

        // Trouver la conversation existante ou en créer une nouvelle
        Conversation? existingConversation = _findConversationByDeliveryId(deliveryId);

        if (existingConversation != null) {
          // Ajouter le message à la conversation existante
          final updatedConversation = existingConversation.addMessage(message);
          _updateConversation(updatedConversation);
        } else {
          // Créer une nouvelle conversation
          _createNewConversation(message, deliveryId);
        }

        // Sauvegarder les conversations dans le stockage local
        _saveConversationsToStorage();

        // Notifier les auditeurs du changement
        _notifyConversationsChanged();
      });
    } catch (e) {
      _handleError('Erreur lors du traitement du message entrant: $e');
    }
  }

  /// Trouve une conversation par ID de livraison
  Conversation? _findConversationByDeliveryId(String deliveryId) {
    try {
      return _conversations.firstWhere(
        (conversation) => conversation.deliveryId == deliveryId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Met à jour une conversation existante
  void _updateConversation(Conversation updatedConversation) {
    final index = _conversations.indexWhere(
      (conversation) => conversation.id == updatedConversation.id,
    );

    if (index != -1) {
      _conversations[index] = updatedConversation;
    } else {
      _conversations.add(updatedConversation);
    }

    // Trier les conversations par date du dernier message (plus récent en premier)
    _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  /// Crée une nouvelle conversation à partir d'un message
  Future<void> _createNewConversation(ConversationMessage message, String deliveryId) async {
    try {
      // Pour déterminer le titre de la conversation, on aurait besoin de plus d'informations
      // Nous pourrions faire un appel API ici pour obtenir le nom de l'entreprise/transporteur
      // Pour l'instant, on utilise un titre générique
      final String title = 'Livraison #${deliveryId.substring(0, 4)}';

      final newConversation = Conversation.createWithInitialMessage(
        id: deliveryId, // Utiliser l'ID de livraison comme ID de conversation
        title: title,
        deliveryId: deliveryId,
        initialMessage: message,
      );

      _conversations.add(newConversation);

      // Trier les conversations
      _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    } catch (e) {
      _handleError('Erreur lors de la création d\'une nouvelle conversation: $e');
    }
  }

  /// Gère la connexion établie
  void _handleConnection() {
    _connectionStatusController.add(true);
    debugPrint('🟢 WebSocket connecté dans WebSocketManager');
  }

  /// Gère les erreurs
  void _handleError(String error) {
    _errorController.add(error);
    _connectionStatusController.add(false);
    debugPrint('🔴 Erreur dans WebSocketManager: $error');
  }

  /// Envoie un message d'acceptation d'offre
Future<bool> sendAcceptOffer(String deliveryId, String receiverId, String offerAmount) async {
    final result = await _chatService.sendAcceptOffer(deliveryId, receiverId, offerAmount);

    if (result) {
      // Le message sera ajouté à la conversation lorsqu'il sera reçu via le WebSocket
      debugPrint('📤 Offre acceptée envoyée avec succès');

      // Fermer la conversation correspondante si elle existe
      await closeConversationAfterDecision(deliveryId);
    }

    return result;
  }

  /// Envoie un message de refus d'offre
Future<bool> sendDeclineOffer(String deliveryId, String receiverId) async {
    final result = await _chatService.sendDeclineOffer(deliveryId, receiverId);

    if (result) {
      // Le message sera ajouté à la conversation lorsqu'il sera reçu via le WebSocket
      debugPrint('📤 Offre refusée envoyée avec succès');

      // Fermer la conversation correspondante si elle existe
      await closeConversationAfterDecision(deliveryId);
    }

    return result;
  }

  /// Envoie une offre simple
  Future<bool> sendSimpleOffer(String deliveryId, String receiverId, String amount) async {
    final result = await _chatService.sendSimpleOffer(deliveryId, receiverId, amount);

    if (result) {
      // Le message sera ajouté à la conversation lorsqu'il sera reçu via le WebSocket
      debugPrint('📤 Offre simple envoyée avec succès');
    }

    return result;
  }

  /// Charge les conversations depuis le stockage local
  Future<void> _loadConversationsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? conversationsJson = prefs.getString(_conversationsStorageKey);

      if (conversationsJson != null && conversationsJson.isNotEmpty) {
        final userDetails = await GeneralManagerDB.getUserDetails();
        if (userDetails == null) return;

        // Décodage JSON de manière sécurisée
        List<dynamic> conversationsList;
        try {
          // Utiliser compute pour le décodage JSON intensif
          conversationsList = await compute<String, List<dynamic>>(
            _parseConversationsJson,
            conversationsJson,
          );
        } catch (e) {
          // Fallback si compute échoue
          conversationsList = List<dynamic>.from(jsonDecode(conversationsJson));
        }

        _conversations.clear();
        for (final conversationJson in conversationsList) {
          _conversations.add(
            Conversation.fromJson(conversationJson, userDetails.id ?? ''),
          );
        }

        // Trier les conversations
        _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

        _notifyConversationsChanged();
      }
    } catch (e) {
      _handleError('Erreur lors du chargement des conversations: $e');
    }
  }

  // Fonction pure pour le parsing JSON dans un isolate
  static List<dynamic> _parseConversationsJson(String json) {
    return List<dynamic>.from(jsonDecode(json));
  }

  /// Sauvegarde les conversations dans le stockage local
  Future<void> _saveConversationsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> conversationsData = _conversations.map((conversation) => conversation.toJson()).toList();

      String conversationsJson;
      try {
        // Utiliser compute pour l'encodage JSON intensif
        conversationsJson = await compute<List<Map<String, dynamic>>, String>(
          _encodeConversationsData,
          conversationsData,
        );
      } catch (e) {
        // Fallback si compute échoue
        conversationsJson = jsonEncode(conversationsData);
      }

      await prefs.setString(_conversationsStorageKey, conversationsJson);
    } catch (e) {
      _handleError('Erreur lors de la sauvegarde des conversations: $e');
    }
  }

  /// Marque une conversation comme terminée après acceptation ou refus
  Future<void> closeConversationAfterDecision(String conversationId) async {
    final existingConversation = _findConversationByDeliveryId(conversationId);

    if (existingConversation != null) {
      final updatedConversation = existingConversation.copyWith(
        isComplete: true,
      );

      _updateConversation(updatedConversation);
      _notifyConversationsChanged();
      await _saveConversationsToStorage();
    }
  }

  // Fonction pure pour l'encodage JSON dans un isolate
  static String _encodeConversationsData(List<Map<String, dynamic>> data) {
    return jsonEncode(data);
  }

  /// Notifie les auditeurs que les conversations ont changé
  void _notifyConversationsChanged() {
    _conversationsController.add(_conversations);
  }

  /// Retourne la liste des conversations
  List<Conversation> get conversations => List.unmodifiable(_conversations);

  /// Stream pour observer les changements de conversations
  Stream<List<Conversation>> get conversationsStream => _conversationsController.stream;

  /// Stream pour observer les erreurs
  Stream<String> get errorStream => _errorController.stream;

  /// Stream pour observer le statut de connexion
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  /// Retourne l'état actuel de la connexion
  bool get isConnected => _chatService.isConnected;

  /// Déconnecte le WebSocket
  void disconnect() {
    _chatService.disconnect();
    _connectionStatusController.add(false);
  }

  /// Dispose des ressources
  void dispose() {
    _chatService.removeMessageCallback(_handleIncomingMessage);
    _chatService.removeConnectionCallback(_handleConnection);
    _chatService.removeErrorCallback(_handleError);

    _chatService.disconnect();

    _conversationsController.close();
    _errorController.close();
    _connectionStatusController.close();
  }
}
