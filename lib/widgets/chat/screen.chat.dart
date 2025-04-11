part of 'widget.chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String path = '/chat';
  static const String name = 'Chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketManager _webSocketManager = WebSocketManager();
  List<Conversation> _conversations = [];
  Conversation? _selectedConversation;
  bool _isLoading = true;
  bool _isConnected = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // S'abonner aux streams
    _webSocketManager.conversationsStream.listen((conversations) {
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    });

    _webSocketManager.connectionStatusStream.listen((isConnected) {
      setState(() {
        _isConnected = isConnected;
        if (isConnected) {
          _errorMessage = null;
        }
      });
    });

    _webSocketManager.errorStream.listen((error) {
      setState(() {
        _errorMessage = error;
      });
    });

    // Récupérer l'état initial
    setState(() {
      _conversations = _webSocketManager.conversations;
      _isConnected = _webSocketManager.isConnected;
      _isLoading = false;
    });
  }

  void _selectConversation(Conversation conversation) {
    setState(() {
      _selectedConversation = conversation;
    });
  }

  void _closeConversation() {
    setState(() {
      _selectedConversation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildChatHeader(),
            if (_errorMessage != null) _buildErrorBanner(),
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                : _selectedConversation != null
                    ? _buildConversationDetail()
                    : Expanded(
                        child: _conversations.isEmpty ? _buildEmptyState() : _buildConversationsList(),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedConversation != null
                  ? GestureDetector(
                      onTap: _closeConversation,
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Conversations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
              _buildConnectionStatus(),
            ],
          ),
          if (_selectedConversation == null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher une conversation...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        // Filtrer les conversations
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isConnected ? Icons.wifi : Icons.wifi_off,
            size: 16,
            color: _isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            _isConnected ? 'Connecté' : 'Déconnecté',
            style: TextStyle(
              fontSize: 12,
              color: _isConnected ? Colors.green : Colors.red,
            ),
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

  Widget _buildConversationsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _conversations.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        final lastMessage = conversation.lastMessage;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              conversation.title.isNotEmpty ? conversation.title[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  conversation.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (conversation.hasUnreadMessages)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: lastMessage != null
              ? Text(
                  _getMessagePreview(lastMessage),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conversation.hasUnreadMessages ? Colors.black87 : Colors.grey[600],
                    fontWeight: conversation.hasUnreadMessages ? FontWeight.w500 : FontWeight.normal,
                  ),
                )
              : const Text('Aucun message'),
          trailing: lastMessage != null
              ? Text(
                  _formatTime(lastMessage.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )
              : null,
          onTap: () => _selectConversation(conversation),
        );
      },
    );
  }

  String _getMessagePreview(ConversationMessage message) {
    switch (message.type) {
      case MessageType.offer:
        return 'Offre: ${message.content} XOF';
      case MessageType.acceptOffer:
        return 'Offre acceptée: ${message.content} XOF';
      case MessageType.declineOffer:
        return 'Offre refusée';
      case MessageType.text:
        return message.content;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('dd/MM').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'à l\'instant';
    }
  }

  Widget _buildConversationDetail() {
    if (_selectedConversation == null) return const SizedBox();

    return Expanded(
      child: ConversationDetailScreen(
        conversation: _selectedConversation!,
        webSocketManager: _webSocketManager,
        onBack: _closeConversation,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration ou icône
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Titre
            const Text(
              'Aucune conversation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'Vos conversations avec les clients et l\'équipe support apparaîtront ici',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Information supplémentaire
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Comment ça marche ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Les conversations sont créées automatiquement lorsque vous acceptez une livraison ou lorsqu\'un client vous contacte directement.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Column(
              children: [
                // Bouton principal
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigation vers la page d'accueil
                      context.pushNamed(HomeScreen.name);
                    },
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Voir les commandes disponibles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Bouton pour rafraîchir
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _initializeChat,
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('Rafraîchir les conversations'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
