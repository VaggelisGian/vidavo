import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_data.dart';

class MessageService {
  static const String _messagesKey = 'saved_messages';

  Future<List<MessageData>> getMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? messagesJson = prefs.getString(_messagesKey);

      if (messagesJson == null) {
        return [];
      }

      final List<dynamic> messagesList = jsonDecode(messagesJson);
      return messagesList.map((json) => MessageData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveMessage(MessageData message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = await getMessages();

      messages.add(message);

      final String messagesJson = jsonEncode(
        messages.map((message) => message.toJson()).toList(),
      );

      await prefs.setString(_messagesKey, messagesJson);
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  Future<void> deleteMessage(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = await getMessages();

      messages.removeWhere((message) => message.id == id);

      final String messagesJson = jsonEncode(
        messages.map((message) => message.toJson()).toList(),
      );

      await prefs.setString(_messagesKey, messagesJson);
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  Future<void> clearAllMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_messagesKey);
    } catch (e) {
      throw Exception('Failed to clear messages: $e');
    }
  }
}
