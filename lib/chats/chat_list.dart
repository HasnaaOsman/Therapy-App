import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat_screen.dart'; // صفحة الشات

class ChatListScreen extends StatefulWidget {
  final String userEmail; // الإيميل الخاص بالمستخدم

  ChatListScreen({required this.userEmail});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Map<String, dynamic>? userChat; // تخزين محادثة المستخدم

  @override
  void initState() {
    super.initState();
    fetchUserChat();
  }

  Future<void> fetchUserChat() async {
    final response = await http.get(
      Uri.parse("https://graduation-api-production.up.railway.app/all-chat"),
    );

    if (response.statusCode == 200) {
      List<dynamic> chats = jsonDecode(response.body);
      var chat = chats.firstWhere(
        (c) => c['email'] == widget.userEmail, // البحث عن محادثة المستخدم
        orElse: () => {},
      );

      setState(() {
        userChat = chat.isNotEmpty ? chat : null;
      });
    } else {
      print("Error fetching chats: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat History")),
      body: userChat == null
          ? Center(child: Text("No chat found"))
          : Card(
              child: ListTile(
                title: Text("Your Chat"),
                subtitle: Text("Tap to open your chat history"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
