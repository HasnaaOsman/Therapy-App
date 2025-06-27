import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/phone_field.dart';

class EditPhonePage extends StatefulWidget {
  const EditPhonePage({super.key});

  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController phoneController = TextEditingController();

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
          phoneController.text = doc['phone'] ?? "";
        });
      }
    }
  }

  // دالة لعرض رسالة النجاح
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

  // دالة لعرض رسالة الخطأ
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

  Future<void> _savePhone() async {
    if (user != null) {
      try {
        // تحديث الهاتف في Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'phone': phoneController.text,
        });

        // عرض رسالة نجاح بعد التحديث
        _showSuccessMessage("Phone changed successfully.");

        // العودة إلى الصفحة السابقة بعد نجاح العملية
        // استخدم await لضمان الانتهاء من العملية قبل العودة
        await Future.delayed(
            const Duration(seconds: 1)); // يمكنك تحديد وقت تأخير مناسب
        Navigator.pop(context);
      } catch (e) {
        // عرض رسالة خطأ في حالة حدوث مشكلة
        _showErrorMessage("Something went wrong. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Phone",style:TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhoneField(
                  hinttext: '000 000 0000 ',
                  mycontroller: phoneController,
                  text: 'Phone',
                  icon: Icon(
                    Icons.phone,
                    color: AppColor.lightGrey,),
                  x: TextInputType.phone,),
                SizedBox(height: 56), 
                CustomButton(text: "Save", onPressed: _savePhone),],
            ),
          ),
        ]),
      ),
    );
  }
}
