import 'package:intl/intl.dart';

/// Énumération des différents types de messages dans une conversation
enum MessageType {
  /// Message d'offre normale
  offer,

  /// Message d'acceptation d'offre
  acceptOffer,

  /// Message de refus d'offre
  declineOffer,

  /// Message texte simple
  text,
}

/// Classe représentant un message dans une conversation
class ConversationMessage {
  /// Identifiant unique du message
  final String? id;

  /// Date et heure du message
  final DateTime timestamp;

  /// Contenu du message (peut être un texte ou un montant)
  final String content;

  /// Type du message (offer, acceptOffer, declineOffer, text)
  final MessageType type;

  /// ID de l'expéditeur du message
  final String? senderUserId;

  /// ID du destinataire du message
  final String? receiverUserId;

  /// ID de la livraison associée au message
  final String? deliveryId;

  /// Flag indiquant si le message a été envoyé par l'utilisateur actuel
  final bool isSentByMe;

  ConversationMessage({
    this.id,
    required this.timestamp,
    required this.content,
    required this.type,
    this.senderUserId,
    this.receiverUserId,
    this.deliveryId,
    required this.isSentByMe,
  });

  /// Crée un objet ConversationMessage à partir d'un objet JSON reçu du serveur
  factory ConversationMessage.fromJson(Map<String, dynamic> json, String currentUserId) {
    // Déterminer le type de message à partir du statut
    MessageType messageType;
    switch (json['statut']) {
      case 'OFFER':
        messageType = MessageType.offer;
        break;
      case 'ACCEPT_T':
        messageType = MessageType.acceptOffer;
        break;
      case 'DECLINE_T':
        messageType = MessageType.declineOffer;
        break;
      default:
        messageType = MessageType.text;
    }

    // Convertir la date du message
    DateTime timestamp;
    try {
      timestamp = DateTime.parse(json['dateMessage']);
    } catch (e) {
      timestamp = DateTime.now();
    }

    // Déterminer si le message a été envoyé par l'utilisateur actuel
    final isSentByMe = json['envoyeurId'] == currentUserId;

    return ConversationMessage(
      id: json['id'],
      timestamp: timestamp,
      content: json['contenu'] ?? '',
      type: messageType,
      senderUserId: json['envoyeurId'],
      receiverUserId: json['recepteurId'],
      deliveryId: json['livraisonId'],
      isSentByMe: isSentByMe,
    );
  }

  /// Convertir le message en objet JSON pour l'envoi au serveur
  Map<String, dynamic> toJson() {
    String statut;
    switch (type) {
      case MessageType.offer:
        statut = 'OFFER';
        break;
      case MessageType.acceptOffer:
        statut = 'ACCEPT_T';
        break;
      case MessageType.declineOffer:
        statut = 'DECLINE_T';
        break;
      case MessageType.text:
        statut = 'TEXT';
        break;
    }

    return {
      'id': id ?? '',
      'dateMessage': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(timestamp),
      'statut': statut,
      'livraisonId': deliveryId,
      'envoyeurId': senderUserId,
      'recepteurId': receiverUserId,
      'contenu': content,
    };
  }

  /// Retourne une copie de l'objet avec certains attributs modifiés
  ConversationMessage copyWith({
    String? id,
    DateTime? timestamp,
    String? content,
    MessageType? type,
    String? senderUserId,
    String? receiverUserId,
    String? deliveryId,
    bool? isSentByMe,
  }) {
    return ConversationMessage(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      type: type ?? this.type,
      senderUserId: senderUserId ?? this.senderUserId,
      receiverUserId: receiverUserId ?? this.receiverUserId,
      deliveryId: deliveryId ?? this.deliveryId,
      isSentByMe: isSentByMe ?? this.isSentByMe,
    );
  }
}
