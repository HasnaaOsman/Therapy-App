import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      "https://api-production-8924.up.railway.app/chat-with-ai";

  Future<String> sendMessageToAI(String message, String email) async {
    try {
      print("🚀 Sending request to AI Model...");

      var response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "message": message}),
          )
          .timeout(Duration(seconds: 30)); 

      print("🔄 Response Status: ${response.statusCode}");
      print("🔄 Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Server error, try again later.");
      }

      dynamic aiData;
      try {
        aiData = jsonDecode(response.body);
        print("🔍 AI Data Type: ${aiData.runtimeType}");
      } catch (e) {
        throw Exception("JSON parsing error: $e");
      }

      String botResponse = "";

      // ✅ التحقق من نوع الاستجابة ومعالجتها بنفس الطريقة
      if (aiData is String) {
        botResponse = aiData;
      } else if (aiData is List &&
          aiData.isNotEmpty &&
          aiData[0] is Map<String, dynamic>) {
        aiData =
            aiData[0]; 
      }

      // if (aiData is Map<String, dynamic> && aiData.containsKey("response")) {
      //   botResponse = aiData["response"];
      // }
      // else {
      //   throw Exception("⚠ Unexpected response from the model");
      // }

      print("🤖 AI Response: $botResponse");
      return botResponse;
    } catch (e) {
      print("❌ Error: $e");
      return "Something went wrong, please try again. ";
    }
  }
}
