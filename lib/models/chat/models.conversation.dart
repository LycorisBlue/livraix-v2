import 'dart:convert';
import 'package:livraix/models/chat/models.conversation_message.dart';

/// Classe représentant une conversation complète
class Conversation {
  /// Identifiant unique de la conversation (généralement l'ID de la livraison)
  final String id;

  /// Titre de la conversation (nom de l'entreprise ou du transporteur)
  final String title;

  /// Détails supplémentaires (optional)
  final String? subtitle;

  /// ID de l'entreprise dans la conversation
  final String? companyId;

  /// ID du transporteur dans la conversation
  final String? transporterId;

  /// ID de la livraison associée
  final String deliveryId;

  /// Liste des messages dans la conversation
  final List<ConversationMessage> messages;

  /// Indique si la conversation a des messages non lus
  final bool hasUnreadMessages;

  /// Indique si la conversation est terminée (acceptation ou refus)
  final bool isComplete;

  /// Date du dernier message dans la conversation
  final DateTime lastMessageTime;

  Conversation({
    required this.id,
    required this.title,
    this.subtitle,
    this.companyId,
    this.transporterId,
    required this.deliveryId,
    required this.messages,
    this.hasUnreadMessages = false,
    this.isComplete = false,
    DateTime? lastMessageTime,
  }) : lastMessageTime = lastMessageTime ?? (messages.isNotEmpty ? messages.last.timestamp : DateTime.now());

  /// Retourne le dernier message de la conversation
  ConversationMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Ajoute un nouveau message à la conversation
  Conversation addMessage(ConversationMessage message) {
    final updatedMessages = List<ConversationMessage>.from(messages)..add(message);

    // Si c'est une acceptation ou un refus, marquer la conversation comme terminée
    bool isComplete = false;
    if (message.type == MessageType.acceptOffer || message.type == MessageType.declineOffer) {
      isComplete = true;
    }

    return copyWith(
      messages: updatedMessages,
      lastMessageTime: message.timestamp,
      isComplete: isComplete, // Nouveau paramètre à ajouter
    );
  }

  /// Crée une conversation à partir des données JSON
  factory Conversation.fromJson(Map<String, dynamic> json, String currentUserId) {
    // Extraire et convertir les messages
    List<ConversationMessage> messagesList = [];
    if (json['messages'] != null) {
      messagesList = (json['messages'] as List).map((msgJson) => ConversationMessage.fromJson(msgJson, currentUserId)).toList();

      // Trier les messages par date
      messagesList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    // Vérifier si la conversation est complète (contient un message d'acceptation ou de refus)
    bool isComplete = false;
    if (messagesList.isNotEmpty) {
      isComplete = messagesList.any((msg) => msg.type == MessageType.acceptOffer || msg.type == MessageType.declineOffer);
    }

    return Conversation(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Conversation',
      subtitle: json['subtitle'],
      companyId: json['companyId'],
      transporterId: json['transporterId'],
      deliveryId: json['deliveryId'] ?? '',
      messages: messagesList,
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
      isComplete: json['isComplete'] ?? isComplete,
      lastMessageTime: messagesList.isNotEmpty ? messagesList.last.timestamp : DateTime.now(),
    );
  }

  /// Convertit la conversation en objet JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'companyId': companyId,
      'transporterId': transporterId,
      'deliveryId': deliveryId,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'hasUnreadMessages': hasUnreadMessages,
      'isComplete': isComplete,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }

  /// Retourne une copie de l'objet avec certains attributs modifiés
  Conversation copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? companyId,
    String? transporterId,
    String? deliveryId,
    List<ConversationMessage>? messages,
    bool? hasUnreadMessages,
    bool? isComplete,
    DateTime? lastMessageTime,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      companyId: companyId ?? this.companyId,
      transporterId: transporterId ?? this.transporterId,
      deliveryId: deliveryId ?? this.deliveryId,
      messages: messages ?? this.messages,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      isComplete: isComplete ?? this.isComplete,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  /// Crée une conversation avec un message initial
  static Conversation createWithInitialMessage({
    required String id,
    required String title,
    String? subtitle,
    String? companyId,
    String? transporterId,
    required String deliveryId,
    required ConversationMessage initialMessage,
    bool isComplete = false,
  }) {
    // Déterminer si la conversation est complète en fonction du type de message initial
    // (par exemple, si c'est une acceptation ou un refus)
    final bool isMessageComplete =
        initialMessage.type == MessageType.acceptOffer || initialMessage.type == MessageType.declineOffer;

    return Conversation(
      id: id,
      title: title,
      subtitle: subtitle,
      companyId: companyId,
      transporterId: transporterId,
      deliveryId: deliveryId,
      messages: [initialMessage],
      hasUnreadMessages: false,
      isComplete: isComplete || isMessageComplete, // Si le message est d'acceptation/refus ou si isComplete est spécifié
      lastMessageTime: initialMessage.timestamp,
    );
  }
}
