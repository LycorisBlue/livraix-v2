part of 'widget.chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String path = '/chat';
  static const String name = 'Chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ChatbotService _chatbotService = ChatbotService();
  final ChatStorageService _storageService = ChatStorageService();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  UserDetails? _userDetails;
  List<ChatContact> _contacts = []; // Liste vide des contacts

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Chargement des données utilisateur
      final userDetails = await GeneralManagerDB.getUserDetails();

      // Dans une application réelle, vous chargeriez les conversations depuis une API
      await Future.delayed(const Duration(milliseconds: 800));

      // Aucune conversation n'est disponible à ce stade
      setState(() {
        _userDetails = userDetails;
        _contacts = []; // Liste vide
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildChatHeader(),
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                : Expanded(
                    child: _contacts.isEmpty ? _buildEmptyState() : _buildConversationsList(),
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
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_outlined),
                color: AppColors.primary,
                onPressed: _loadData,
              ),
            ],
          ),
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
                    enabled: false, // Désactivé car aucune conversation
                    decoration: InputDecoration(
                      hintText: 'Rechercher une conversation...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

                // Bouton secondaire : contacter le support
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _contactSupport,
                    icon: const Icon(Icons.support_agent_outlined),
                    label: const Text('Contacter le support'),
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

  Widget _buildConversationsList() {
    // Cette méthode ne sera pas appelée actuellement car la liste est vide,
    // mais est incluse pour complétude
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _contacts.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(contact.name),
          subtitle: Text(
            contact.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            contact.lastMessageTime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          onTap: () {
            // Navigation vers la conversation
          },
        );
      },
    );
  }

  void _contactSupport() {
    // Dans une application réelle, ceci créerait une conversation avec le support
    // Pour l'instant, nous simulons une conversation avec l'assistant virtuel

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion à l\'assistant virtuel...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Naviguer vers l'assistant virtuel
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      // Créer une conversation avec l'assistant
      final assistantChat = ChatScreen.path; // Dans une implémentation réelle, ceci serait un path spécifique
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VirtualAssistantChat(),
        ),
      );
    });
  }
}

// Modèle simple pour les contacts de chat
class ChatContact {
  final String id;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final bool unread;

  ChatContact({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unread = false,
  });
}

// Widget fictif pour l'assistant virtuel
class VirtualAssistantChat extends StatelessWidget {
  const VirtualAssistantChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assistant Virtuel'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                size: 80,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(height: 24),
              const Text(
                'Assistant virtuel en cours de développement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Cette fonctionnalité sera bientôt disponible pour vous aider dans vos livraisons.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
