import 'package:flutter/material.dart';
import 'package:livraix/models/chat/models.conversation.dart';
import 'package:livraix/models/chat/models.conversation_message.dart';
import 'package:livraix/utils/app.websocket_manager.dart';
import 'package:livraix/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:math' as Math;

class ConversationDetailScreen extends StatefulWidget {
  final Conversation conversation;
  final WebSocketManager webSocketManager;
  final VoidCallback onBack;

  const ConversationDetailScreen({
    Key? key,
    required this.conversation,
    required this.webSocketManager,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ConversationDetailScreen> createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Conversation _conversation = Conversation(
    id: "",
    title: "",
    deliveryId: "",
    messages: [],
  );

  bool _isShowingOfferInput = false;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;

    // S'abonner aux mises à jour des conversations
    widget.webSocketManager.conversationsStream.listen((conversations) {
      // Trouver la conversation actuelle dans la liste mise à jour
      final updatedConversation = conversations.firstWhere(
        (conv) => conv.id == _conversation.id,
        orElse: () => _conversation,
      );

      setState(() {
        _conversation = updatedConversation;
      });

      // Faire défiler vers le bas lorsqu'un nouveau message arrive
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _offerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendOffer() async {
    if (_offerController.text.isEmpty) return;

    final offerAmount = _offerController.text.trim();

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.webSocketManager.sendSimpleOffer(
        _conversation.deliveryId,
        _conversation.companyId ?? "",
        offerAmount,
      );

      if (!success) {
        setState(() {
          _errorMessage = "Échec de l'envoi de l'offre. Veuillez réessayer.";
        });
      } else {
        _offerController.clear();
        setState(() {
          _isShowingOfferInput = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Une erreur est survenue: $e";
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _sendTextMessage() async {
    if (_messageController.text.isEmpty) return;

    // Cette fonctionnalité n'est pas encore implémentée dans WebSocketManager
    // Pour l'instant, nous affichons juste un message d'erreur
    setState(() {
      _errorMessage = "L'envoi de messages texte n'est pas encore disponible.";
      _messageController.clear();
    });
  }


@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildConversationHeader(),
        if (_errorMessage != null) _buildErrorBanner(),
        Expanded(
          child: _buildMessagesList(),
        ),
        _buildActionButtons(), // Ajout des boutons d'action pour accepter/refuser
        _isShowingOfferInput ? _buildOfferInput() : _buildMessageInput(),
      ],
    );
  }

  Widget _buildConversationHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              _conversation.title.isNotEmpty ? _conversation.title[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _conversation.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Livraison ID: ${_conversation.deliveryId.substring(0, Math.min(_conversation.deliveryId.length, 8))}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onBack,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade50,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage ?? 'Une erreur est survenue',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _errorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_conversation.messages.isEmpty) {
      return const Center(
        child: Text(
          'Aucun message dans cette conversation',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _conversation.messages.length,
      itemBuilder: (context, index) {
        final message = _conversation.messages[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(ConversationMessage message) {
    final isMe = message.isSentByMe;

    switch (message.type) {
      case MessageType.offer:
        return _buildOfferMessage(message, isMe);
      case MessageType.acceptOffer:
        return _buildAcceptOfferMessage(message);
      case MessageType.declineOffer:
        return _buildDeclineOfferMessage(message);
      case MessageType.text:
        return _buildTextMessage(message, isMe);
    }
  }

  Widget _buildOfferMessage(ConversationMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMe ? AppColors.primary.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isMe ? 'Votre offre' : 'Offre reçue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isMe ? AppColors.primary : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${message.content} XOF',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptOfferMessage(ConversationMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(height: 4),
          const Text(
            'Offre acceptée',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${message.content} XOF',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(message.timestamp),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclineOfferMessage(ConversationMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.cancel,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(height: 4),
          const Text(
            'Offre refusée',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(message.timestamp),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextMessage(ConversationMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            color: AppColors.primary,
            onPressed: () {
              setState(() {
                _isShowingOfferInput = true;
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Tapez un message...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendTextMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Envoyer une offre (XOF)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _offerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Montant...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    suffixText: 'XOF',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSending ? null : _sendOffer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Envoyer'),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isShowingOfferInput = false;
                    _offerController.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Ajout de cette méthode dans la classe _ConversationDetailScreenState

  Widget _buildActionButtons() {
    // Vérifier si c'est une conversation en cours de négociation
    bool isNegotiating = true; // TODO: Implémenter une logique pour détecter si la livraison est déjà acceptée

    if (!isNegotiating) return const SizedBox.shrink(); // Ne pas afficher les boutons si déjà acceptée

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Refuser'),
              onPressed: () => _confirmAction(
                'Refuser la livraison',
                'Êtes-vous sûr de vouloir refuser définitivement cette livraison ?',
                _sendDeclineOffer,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.red.shade200),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Accepter'),
              onPressed: () => _confirmAction(
                'Accepter la livraison',
                'Êtes-vous sûr de vouloir accepter définitivement cette livraison aux conditions actuelles ?',
                _sendAcceptOffer,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                foregroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.green.shade200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAction(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
              onConfirm(); // Exécuter l'action confirmée
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendAcceptOffer() async {
    // Récupérer le dernier montant proposé
    final lastOffer = _findLastOfferAmount();

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.webSocketManager.sendAcceptOffer(
        _conversation.deliveryId,
        _conversation.companyId ?? "",
        lastOffer ?? "0",
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livraison acceptée avec succès!')),
        );

        // Optionnel: Fermer la conversation et revenir à la liste
        // widget.onBack();
      } else {
        setState(() {
          _errorMessage = "Échec de l'acceptation. Veuillez réessayer.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Une erreur est survenue: $e";
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _sendDeclineOffer() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.webSocketManager.sendDeclineOffer(
        _conversation.deliveryId,
        _conversation.companyId ?? "",
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livraison refusée')),
        );

        // Fermer la conversation et revenir à la liste
        widget.onBack();
      } else {
        setState(() {
          _errorMessage = "Échec du refus. Veuillez réessayer.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Une erreur est survenue: $e";
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  // Fonction utilitaire pour trouver le dernier montant d'offre dans la conversation
  String? _findLastOfferAmount() {
    // Parcourir la liste des messages en sens inverse pour trouver la dernière offre
    for (int i = _conversation.messages.length - 1; i >= 0; i--) {
      final message = _conversation.messages[i];
      if (message.type == MessageType.offer) {
        return message.content;
      }
    }
    return null; // Aucune offre trouvée
  }
}

