import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/chat/pages/chat_history.dart';
import 'package:therapy/screen/chat/pages/gudeline.dart';
import 'package:therapy/screen/chat/services/api.dart';
import 'package:therapy/screen/chat/services/firestore_chat.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/typing.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;

  const ChatScreen({super.key, this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    if (chatId != null) {
      _loadMessages(chatId!);
    }
  }

  /// *تحميل الرسائل من Firestore*
  void _loadMessages(String chatId) async {
    try {
      List<Map<String, dynamic>> loadedMessages =
          await FirestoreService().getMessagesByChatId(chatId);
      if (mounted) {
        setState(() {
          messages = loadedMessages;
        });
      }
      _scrollToBottom();
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  /// *جلب البريد الإلكتروني للمستخدم الحالي*
  Future<String> getUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return "unknown@example.com";
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return userDoc.exists && userDoc.data() != null
          ? (userDoc['email'] ?? "unknown@example.com")
          : "unknown@example.com";
    } catch (e) {
      print("Error getting user email: $e");
      return "unknown@example.com";
    }
  }

  /// *إرسال الرسالة*
  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add({"text": message, "isMe": true});
      isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // جلب البريد الإلكتروني للمستخدم
      String email = await getUserEmail();

      // التأكد من أن chatId غير فارغ قبل إرسال الرسالة
      if (chatId == null) {
        chatId = await FirestoreService().createNewChat(message);
        if (chatId == null) {
          setState(() => isTyping = false);
          return;
        }
      }

      // إرسال الرسالة إلى API والحصول على الرد
      String aiResponse = await ApiService().sendMessageToAI(message, email);

      if (mounted) {
        setState(() {
          messages.add({"text": aiResponse, "isMe": false});
          isTyping = false;
        });
      }

      // حفظ الرسالة في Firestore
      await FirestoreService().saveMessage(chatId!, message, aiResponse);
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
      setState(() => isTyping = false);
    }
  }

  /// *التمرير إلى أسفل المحادثة عند إضافة رسالة جديدة*
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuidelinesPage()),
              );
            },
            icon: Icon(
              Icons.info_outline,
              color: AppColor.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            },
            icon: Icon(Icons.list),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          "AI Chat",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= messages.length) {
                    return TypingIndicator();
                  }
                  return ChatBubble(
                    text: messages[index]["text"],
                    isMe: messages[index]["isMe"],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: AppColor.blue,
                          ),
                        ),
                        hintText: "Type a message...",
                        hintStyle: AppWidget.LightTextFieldStyle(),
                        fillColor: AppColor.white,
                        filled: true,
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lightGrey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: AppColor.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
