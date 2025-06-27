import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/user_field.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          nameController.text = doc['username'] ?? user!.displayName ?? "";
        });
      }
    }
  }

  Future<void> _saveName() async {
    if (user != null) {
      try {
        String newName = nameController.text.trim();

        // تحديث الاسم في Firestore فقط
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'username': newName});

        // إذا أردت تحديث الاسم في Firebase Authentication أيضاً
        // لكن هذا لن يؤثر في حال تسجيل الدخول بواسطة Google، يمكنك إضافة هذا الكود:
        // await user!.updateDisplayName(newName);

        // إعادة تحميل بيانات المستخدم للتأكد من تحديثها في Firebase Authentication
        await user!.reload();

        _showSuccessMessage("Name changed successfully!");

        // تأجيل عملية التنقل لعدة ميلي ثانية لتجنب التداخل
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        _showErrorMessage("Something went wrong: $e");
      }
    }
  }

  void _showSuccessMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  void _showErrorMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Name",
              style:TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserField(
                  hinttext: 'Enter your name',
                  mycontroller: nameController,
                  text: 'Username',
                  icon: Icon(
                    Icons.person,
                    color: AppColor.lightGrey,),
                    x: TextInputType.name,),
                SizedBox(height: 56), 
                CustomButton(text: "Save", onPressed: _saveName),],
            ),
          ),
        ]),
      ),
    );
  }
}
