import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/email_textfiled.dart';

class EditEmailPage extends StatefulWidget {
  const EditEmailPage({super.key});

  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController emailController = TextEditingController();

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
          emailController.text = doc['email'] ?? user!.email ?? "";
        });
      }
    }
  }

  // دالة لعرض رسالة النجاح
  void _showSuccessMessage(String message) {
    if (!mounted) return; // التأكد من أن الـ context ما زال صالحًا
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  // دالة لعرض رسالة الخطأ
  void _showErrorMessage(String message) {
    if (!mounted) return; // التأكد من أن الـ context ما زال صالحًا
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }

  Future<void> _saveEmail() async {
    if (user != null) {
      try {
        await user!.updateEmail(emailController.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'email': emailController.text});

        _showSuccessMessage("Email changed successfully! Please log in again.");

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } catch (e) {
        _showErrorMessage("Something went wrong. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Email",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Textformfeild(
                  hinttext: 'Enter your email',
                  mycontroller: emailController,
                  text: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: AppColor.lightGrey,
                  ),
                  x: TextInputType.emailAddress,
                ),
                const SizedBox(height: 56),
                CustomButton(text: "Save", onPressed: _saveEmail),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
