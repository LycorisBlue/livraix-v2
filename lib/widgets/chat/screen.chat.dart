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

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _storageService.loadMessages();
    setState(() {
      _messages.clear();
      _messages.addAll(messages);
    });

    if (_messages.isEmpty) {
      _addBotWelcomeMessage();
    }
  }

  void _addBotWelcomeMessage() {
    final message = ChatMessage(
      text: "Bonjour! Je suis votre assistant virtuel. Comment puis-je vous aider avec vos besoins en transport de fret?",
      isBot: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
    });
    _storageService.saveMessages(_messages);
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      isBot: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });
    await _storageService.saveMessages(_messages);

    _scrollToBottom();

    // Get bot response
    final response = await _chatbotService.getBotResponse(text);

    final botMessage = ChatMessage(
      text: response,
      isBot: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });
    await _storageService.saveMessages(_messages);

    _scrollToBottom();
  }

  Future<void> _clearMessages() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les messages'),
        content: const Text('Voulez-vous vraiment effacer tous les messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await _storageService.clearMessages();
              setState(() {
                _messages.clear();
              });
              _addBotWelcomeMessage();
              Navigator.pop(context);
            },
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(onClearMessages: _clearMessages),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: _messages[index]);
                },
              ),
            ),
            ChatInput(onSubmitted: _handleSubmitted),
          ],
        ),
      ),
    );
  }
}
