import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/chat/pages/chat.dart';
import 'package:therapy/screen/chat/services/firestore_chat.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chatList = [];
  Set<String> selectedChats = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    chatList = await FirestoreService().getAllChats();
    setState(() {});
  }

  void _toggleSelection(String chatId) {
    setState(() {
      if (selectedChats.contains(chatId)) {
        selectedChats.remove(chatId);
        if (selectedChats.isEmpty) isSelectionMode = false;
      } else {
        selectedChats.add(chatId);
        isSelectionMode = true;
      }
    });
  }

  void _deleteSelectedChats() async {
    bool confirmDelete = await _showDeleteDialog(context);
    if (confirmDelete) {
      for (var chatId in selectedChats) {
        await FirestoreService().deleteChat(chatId);
      }
      selectedChats.clear();
      isSelectionMode = false;
      _loadChats();
      _showFlushbar("Chat deleted successfully", Colors.green);
    }
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        "Are you sure you want to delete selected chats?",
                        textAlign: TextAlign.center,
                        style: AppWidget.GoogleStyle()),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                              right: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      backgroundColor: color,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(Icons.check_circle, color: Colors.white),
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isSelectionMode
          ? AppBar(
              backgroundColor: Colors.white,
              title: Text("${selectedChats.length} Selected",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: IconButton(
                icon: Icon(Icons.close, color: AppColor.lightGrey),
                onPressed: () => setState(() {
                  isSelectionMode = false;
                  selectedChats.clear();
                }),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteSelectedChats, )],)
          : AppBar(
              backgroundColor: Colors.white,
              title: Text("Chats",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
      body: chatList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/Message.png",
                    width: 200,
                    height: 200,
                  ),
                  Text("No saved chats, Start Now",
                      style: AppWidget.DateStyle()),],),)
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: chatList.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var chat = chatList[index];
                        bool isSelected = selectedChats.contains(chat["id"]);
                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.blue.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected
                                ? Border.all(
                                    color: AppColor.blue.withOpacity(0.1),
                                    width: 2)
                                : null, 
                          ),
                          child: ListTile(
                            onTap: isSelectionMode
                                ? () => _toggleSelection(chat["id"])
                                : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(chatId: chat["id"])),
                                    ),
                            onLongPress: () => _toggleSelection(chat["id"]),
                            selected: isSelected,
                            selectedTileColor: AppColor.blue.withOpacity(0.1),
                            leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Image.asset("images/chatbot 1.png"),
                            ),
                            title: Text(
                              chat["preview"] ?? "No preview available",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              chat["date"] ?? "Unknown date",
                              style: TextStyle(color: Colors.grey),),), );},
                      separatorBuilder: (context, index) => Divider(),),),],),),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: FloatingActionButton(
          backgroundColor: AppColor.blue,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),),
          child: Icon(Icons.chat_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
