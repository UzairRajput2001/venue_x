import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final String documentId;

  const ChatPage({super.key, required this.documentId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  final _currentUser = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  final _adminUser = const types.User(id: 'admin', firstName: 'Admin');

  @override
  void initState() {
    super.initState();
    _fetchChatMessages();
  }

  Future<void> _fetchChatMessages() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookingRequests')
          .doc(widget.documentId)
          .collection('chats')
          .orderBy('timestamp',descending: true)
          .get();

      final List<types.Message> messages = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final message = types.TextMessage(
          id: doc.id,
          author: data['sender'] == 'Admin' ? _adminUser : _currentUser,
          text: data['message'],
          createdAt: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
        );
        return message;
      }).toList();

      setState(() {
        _messages.addAll(messages);
      });
    } catch (e) {
      print('Error fetching chat messages: $e');
    }
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      id: const Uuid().v4(),
      author: _currentUser,
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    try {
      await FirebaseFirestore.instance
          .collection('bookingRequests')
          .doc(widget.documentId)
          .collection('chats')
          .add({
        'message': textMessage.text,
        'sender': 'User',
        'timestamp': Timestamp.fromMillisecondsSinceEpoch(textMessage.createdAt!),
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _currentUser,
      ),
    );
  }
}
