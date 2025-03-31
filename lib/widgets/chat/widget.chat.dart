import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:livraix/database/app.generalmanager.dart';
import 'package:livraix/models/chat/models.chat_message.dart';
import 'package:livraix/models/user_cnx_details.dart';
import 'package:livraix/repository/services/services.chat_storage.dart';
import 'package:livraix/repository/services/services.chst_message.dart';
import 'package:livraix/widgets/home/widget.home.dart';
import 'package:livraix/widgets/widgets.dart';

part 'screen.chat.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onClearMessages;

  const ChatHeader({
    super.key,
    required this.onClearMessages,
  });

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/4712/4712009.png'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant Virtuel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'En ligne',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.redAccent,
            onPressed: onClearMessages,
          ),
        ],
      ),
    );
  }
}

//Widget de saisi de texte

class ChatInput extends StatefulWidget {
  final Function(String) onSubmitted;

  const ChatInput({
    super.key,
    required this.onSubmitted,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();

  void _handleSubmit() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      widget.onSubmitted(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Écrivez votre message...',
                hintStyle: const TextStyle(color: Colors.grey),
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
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _handleSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

//Widget de propositions de message

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isBot = message.isBot;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) _buildAvatar(),
          if (isBot) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isBot ? Colors.grey[100] : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isBot ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: isBot ? Colors.grey : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isBot) const SizedBox(width: 8),
          if (!isBot) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/4712/4712009.png'),
    );
  }

  Widget _buildUserAvatar() {
    return const CircleAvatar(
      radius: 16,
      backgroundImage: NetworkImage(
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
    );
  }
}
