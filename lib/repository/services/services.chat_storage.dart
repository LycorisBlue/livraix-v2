import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:livraix/models/chat/models.chat_message.dart';

class ChatStorageService {
  static const String _storageKey = 'chat_messages';

  Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages
        .map((msg) => {
              'text': msg.text,
              'isBot': msg.isBot,
              'timestamp': msg.timestamp.toIso8601String(),
            })
        .toList();
    await prefs.setString(_storageKey, jsonEncode(messagesJson));
  }

  Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_storageKey);
    if (messagesJson == null) return [];

    final List<dynamic> decoded = jsonDecode(messagesJson);
    return decoded
        .map((msg) => ChatMessage(
              text: msg['text'],
              isBot: msg['isBot'],
              timestamp: DateTime.parse(msg['timestamp']),
            ))
        .toList();
  }

  Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
