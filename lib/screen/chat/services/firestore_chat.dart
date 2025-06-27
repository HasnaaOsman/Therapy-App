import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // إضافة الحزمة

class FirestoreService {
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection("chats");

  // دالة لتنسيق التاريخ والوقت مع إضافة مسافة بينهما
  String formatDateTime(DateTime dateTime) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(dateTime); // تنسيق التاريخ
    String formattedTime = DateFormat('HH:mm').format(dateTime); // تنسيق الوقت
    return '$formattedDate            $formattedTime'; // دمج التاريخ والوقت مع مسافة بينهما
  }

  // إنشاء محادثة جديدة عند إرسال أول رسالة
  Future<String> createNewChat(String firstMessage) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String chatId =
        chatsCollection.doc(userId).collection("userChats").doc().id;

    String formattedDateTime = formatDateTime(DateTime.now());

    await chatsCollection.doc(userId).collection("userChats").doc(chatId).set({
      "preview": firstMessage, // حفظ أول رسالة كمُعاينة
      "date": formattedDateTime, // حفظ التاريخ والوقت
      "chatId": chatId,
    });

    return chatId;
  }

  // حفظ رسالة داخل محادثة معينة
  Future<void> saveMessage(
      String chatId, String userMessage, String aiResponse) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    String formattedDateTime = formatDateTime(DateTime.now());

    await chatsCollection
        .doc(userId)
        .collection("userChats")
        .doc(chatId)
        .collection("messages")
        .add({
      "userMessage": userMessage,
      "aiResponse": aiResponse,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // تحديث المعاينة في المحادثة الرئيسية
    await chatsCollection
        .doc(userId)
        .collection("userChats")
        .doc(chatId)
        .update({
      "preview": userMessage,
      "date": formattedDateTime, // حفظ التاريخ والوقت
    });
  }

  // جلب جميع المحادثات الخاصة بالمستخدم
  Future<List<Map<String, dynamic>>> getAllChats() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot chatDocs = await chatsCollection
        .doc(userId)
        .collection("userChats")
        .orderBy("date", descending: true)
        .get();

    return chatDocs.docs.map((doc) {
      return {
        "id": doc.id,
        "preview": doc["preview"] ?? "No preview",
        "date": doc["date"] ?? "No date",
      };
    }).toList();
  }

  // جلب جميع الرسائل الخاصة بمحادثة معينة
  Future<List<Map<String, dynamic>>> getMessagesByChatId(String chatId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc(userId)
          .collection("userChats")
          .doc(chatId)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .get();

      List<Map<String, dynamic>> messages = [];

      for (var doc in querySnapshot.docs) {
        // إضافة رسالة المستخدم
        messages.add({
          "text": doc["userMessage"] ?? "No text",
          "isMe": true, // المستخدم هو المرسل
        });

        // إضافة رد الذكاء الاصطناعي، إذا كان موجودًا
        if (doc["aiResponse"] != null &&
            doc["aiResponse"].toString().trim().isNotEmpty) {
          messages.add({
            "text": doc["aiResponse"],
            "isMe": false, // الذكاء الاصطناعي هو المرسل
          });
        }
      }

      return messages;
    } catch (e) {
      print("Error getting messages: $e");
      return [];
    }
  }

  // حذف محادثة معينة
  Future<void> deleteChat(String chatId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      var messages = await chatsCollection
          .doc(userId)
          .collection("userChats")
          .doc(chatId)
          .collection("messages")
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      await chatsCollection
          .doc(userId)
          .collection("userChats")
          .doc(chatId)
          .delete();
    } catch (e) {
      print("Error deleting chat: $e");
    }
  }
}
