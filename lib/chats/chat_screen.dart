import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:therapy/chats/chat_bunbbl.dart';
import 'package:therapy/chats/chat_list.dart';
import 'package:therapy/chats/loadind_indicator.dart';
import 'package:therapy/chats/message_input.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  String getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email ?? "unknown@gmail.com";
  }

  void showErrorFlushbar(BuildContext context) {
    Flushbar(
      message: "There is a problem connecting to the server, try again later",
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        Icons.error_rounded,
        color: Colors.white,
      ),
    )..show(context);
  }

  Future<void> sendMessage() async {
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"message": userMessage, "isUser": "true"});
      isLoading = true;
    });

    _messageController.clear();
    String email = getUserEmail();

    try {
      print("🚀 Sending request to AI Model...");
      var aiResponse = await http
          .post(
            Uri.parse(
                "https://api-production-8924.up.railway.app/chat-with-ai"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "message": userMessage}),
          )
          .timeout(Duration(seconds: 30));

      print("🔄 Response status: ${aiResponse.statusCode}");
      print("🔄 Response body: ${aiResponse.body}");

      if (aiResponse.statusCode != 200) {
        throw Exception("⚠ خطأ في الخادم، حاول لاحقًا.");
      }

      dynamic aiData;
      try {
        aiData = jsonDecode(aiResponse.body);
        print("🔍 AI Data Type: ${aiData.runtimeType}");
      } catch (e) {
        throw Exception("⚠ خطأ في تحليل JSON: $e");
      }

      String botResponse = "";

      // ✅ التحقق من نوع الاستجابة ومعالجتها بشكل مرن
      if (aiData is String) {
        botResponse = aiData;
      } else if (aiData is List &&
          aiData.isNotEmpty &&
          aiData[0] is Map<String, dynamic>) {
        aiData =
            aiData[0]; // إذا كانت استجابة API عبارة عن List، نأخذ العنصر الأول
      }

      // if (aiData is! Map<String, dynamic> || !aiData.containsKey("response")) {
      //   throw Exception("⚠ استجابة غير متوقعة من السيرفر: $aiData");
      // }

      // botResponse = aiData["response"] ?? "⚠ لم يتم استقبال رد.";
      // print("✅ AI Response: $botResponse");

      // 🟢 تخزين المحادثة في API التخزين
      print("💾 Storing chat in API...");
      var storeResponse = await http
          .post(
            Uri.parse(
                "https://graduation-api-production.up.railway.app/all-chat"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
              "message": userMessage,
              "response": botResponse
            }),
          )
          .timeout(Duration(seconds: 30));

      print("💾 Store Response status: ${storeResponse.statusCode}");
      print("💾 Store Response body: ${storeResponse.body}");

      setState(() {
        messages.add({"message": botResponse, "isUser": "false"});
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      showErrorFlushbar(context);
      // setState(() {
      //   messages.add({
      //     "message": "⚠ هناك مشكلة في الاتصال بالسيرفر، حاول لاحقًا.",
      //     "isUser": "false"
      //   });
      //   isLoading = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    loadChatHistory(); // 🔹 تحميل الرسائل السابقة تلقائيًا
  }

  Future<void> loadChatHistory() async {
    String email = getUserEmail();
    try {
      var response = await http.get(
        Uri.parse(
            "https://graduation-api-production.up.railway.app/user-chat?email=$email"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          messages = data.map<Map<String, String>>((chat) {
            return {
              "message": chat["message"].toString(),
              "isUser": chat["isUser"].toString()
            };
          }).toList();
        });
      }
    } catch (e) {
      print("❌ Error loading chat history: $e");
    }
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
                    MaterialPageRoute(
                        builder: (context) => ChatListScreen(
                              userEmail: '',
                            )),
                  );
                },
                icon: Icon(Icons.list))
          ],
          backgroundColor: Colors.white,
          title: Text("AI Chat",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isLoading) {
                    return LoadingIndicator();
                  }
                  return ChatBubble(
                    message: messages[index]["message"]!,
                    isUser: messages[index]["isUser"] == "true",
                  );
                },
              ),
            ),
            // if (isLoading) LoadingIndicator(),
            MessageInputField(
              controller: _messageController,
              onSend: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
