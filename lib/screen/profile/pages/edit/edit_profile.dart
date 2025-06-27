import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/profile/pages/edit/change_password.dart';
import 'package:therapy/screen/profile/pages/edit/edit_email.dart';
import 'package:therapy/screen/profile/pages/edit/edit_name.dart';
import 'package:therapy/screen/profile/pages/edit/edit_phone.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String name = "";
  String phone = "";
  String email = "";
  String? profileImageUrl;
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchGoogleUserData();
  }

  Future<void> fetchGoogleUserData() async {
    if (user != null) {
      setState(() {
        name = user!.displayName ?? "";
        email = user!.email ?? "";
        phone = user!.phoneNumber ?? "";
      });

      // التحقق من وجود بيانات إضافية في Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          name = doc['name'] ?? name;
          phone = doc['phone'] ?? phone;
        });
      }
    }
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
          name = doc['username'] ?? user!.displayName ?? "";
          phone = doc['phone'] ?? "";
          email = user!.email!;
          profileImageUrl = doc['profileImage'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        profileImageUrl = pickedFile.path;
      });
      // رفع الصورة إلى Firebase Storage وتحديث قاعدة البيانات
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'profileImage': pickedFile.path,
      });
    }
  }

  void _navigateToEditPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        .then((_) {
      _fetchUserData();
    });
  }

  Future<void> _deleteProfilePicture() async {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) {
      _showErrorFlushbar('No profile picture to delete');
      return;
    }

    try {
      Reference ref;

      // Check if profileImageUrl is a full URL or a relative path
      if (profileImageUrl!.startsWith("http") ||
          profileImageUrl!.startsWith("gs://")) {
        // If it's a full URL, use it directly
        ref = FirebaseStorage.instance.refFromURL(profileImageUrl!);
      } else {
        // If it's a relative path, add the appropriate folder (e.g., profile_pictures/)
        ref = FirebaseStorage.instance
            .ref()
            .child("profile_pictures/${profileImageUrl!}");
      }

      // Try to delete the image from Firebase Storage
      await ref.delete();

      // Remove the image from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'profileImage': FieldValue.delete()});

      // Update the UI to remove the image
      setState(() {
        profileImageUrl = null;
      });

      _showSuccessFlushbar('Profile picture deleted successfully');
    } catch (e) {
      // Print the error details for debugging
      print("Error while deleting the picture: $e");
      _showErrorFlushbar('An error occurred while deleting the picture');
    }
  }

  Future<void> updateUserData(String field, String newValue) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        field: newValue,
      });

      setState(() {
        if (field == 'name') name = newValue;
        if (field == 'phone') phone = newValue;
      });

      _showSuccessFlushbar("Updated successfully!");
    }
  }

  void _showSuccessFlushbar(String message) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  void _showErrorFlushbar(String message) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }

  // void _showDeleteConfirmationDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white, // ✅ جعل الخلفية بيضاء بالكامل
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         title: Text(
  //           "Confirm Delete",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //             color: Colors.red.shade700, // ✅ لون العنوان أحمر غامق
  //           ),
  //         ),
  //         content: const Padding(
  //           padding: EdgeInsets.symmetric(vertical: 10.0),
  //           child: Text(
  //             "Are you sure you want to delete the profile image?",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 16, color: Colors.black87),
  //           ),
  //         ),
  //         actionsAlignment: MainAxisAlignment.center, // ✅ توسيط الأزرار
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               _deleteProfilePicture(); // ✅ تنفيذ الحذف
  //               Navigator.of(context).pop();

  //               // ✅ إظهار Flushbar بدل Snackbar
  //               Flushbar(
  //                 message: "Profile picture deleted successfully",
  //                 margin: const EdgeInsets.all(8),
  //                 borderRadius: BorderRadius.circular(8),
  //                 duration: const Duration(seconds: 2),
  //                 flushbarPosition: FlushbarPosition.BOTTOM,
  //                 backgroundColor: Colors.green,
  //                 icon: const Icon(Icons.check_circle, color: Colors.white),
  //               ).show(context);
  //             },
  //             style: TextButton.styleFrom(
  //               foregroundColor: Colors.white,
  //               backgroundColor: Colors.green, // ✅ زر "Yes" بالأخضر
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //             ),
  //             child: const Text(
  //               "Yes",
  //               style: TextStyle(
  //                 //  color: Colors.green,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // ✅ إغلاق النافذة بدون حذف
  //             },
  //             style: TextButton.styleFrom(
  //               foregroundColor: Colors.white,
  //               backgroundColor: Colors.red, // ✅ زر "No" بالأحمر
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //             ),
  //             child: const Text(
  //               "No",
  //               style: TextStyle(
  //                 // color: Colors.red,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Edit Profile",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *0.05, vertical: 24,),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildProfileItem("Name", name, EditNamePage()),
                SizedBox(
                  height: 15,
                ),
                _buildProfileItem("Phone", phone, EditPhonePage()),
                SizedBox(
                  height: 15,
                ),
                _buildProfileItem("Email", email, EditEmailPage()),
                SizedBox(
                  height: 15,
                ),
                _buildProfileItem(
                    "Change Password", "************", ChangePasswordPage()),],),),]),),);}
  Widget _buildProfileItem(String label, String value, Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        elevation: 5,
        child: ListTile(
          title: Text(label, style: AppWidget.BBoldTextStyle()),
          subtitle: Text(value, style: AppWidget.LLightTextFieldStyle()),
          trailing: Image.asset(
            "images/edit.png", 
            width: 20, 
            height: 20, 
          ),
          onTap: () => _navigateToEditPage(page),
        ),
      ),
    );
  }
}
