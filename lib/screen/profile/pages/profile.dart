import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/profile/pages/about_us.dart';
import 'package:therapy/screen/profile/pages/conect_us.dart';
import 'package:therapy/screen/profile/pages/edit/edit_profile.dart';
import 'package:therapy/screen/profile/pages/setting.dart';
import 'package:therapy/screen/profile/photo.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? profileImageUrl;
  File? _image;

  Future<void> _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        setState(() {
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
                Text("Are you sure you want to delete the profile image?",
                    textAlign: TextAlign.center,
                    style: AppWidget.GoogleStyle()),
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
                          onPressed: () {
                            _deleteProfilePicture();
                            Navigator.of(context).pop();

                            // ✅ إظهار Flushbar بعد الحذف
                            Flushbar(
                              message: "Profile picture deleted successfully",
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(8),
                              icon: const Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                            ).show(context);
                          },
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
                          onPressed: () => Navigator.pop(context),
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
        );
      },
    );
  }

  // تسجيل خروج المستخدم
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardMargin = screenWidth * 0.04;
    double textSize = screenWidth * 0.05;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No data found"));
              }
              var userData = snapshot.data!.data() as Map<String, dynamic>?;
              String userName =
                  userData != null && userData.containsKey('username')
                      ? userData['username']
                      : "User Name";
              String userImage =
                  userData?['profileImage'] ?? 'images/avatar.jpg';
              return ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        // GestureDetector(
                        //   onLongPress: profileImageUrl == null ||
                        //           profileImageUrl!.isEmpty
                        //       ? null
                        //       : () {
                        //           _showDeleteConfirmationDialog();
                        //         },
                        //   onTap: _pickImage,
                        //   child: Stack(alignment: Alignment.center, children: [
                        //     CircleAvatar(
                        //       radius: MediaQuery.of(context).size.width * 0.15,
                        //       backgroundImage: profileImageUrl != null
                        //           ? FileImage(File(profileImageUrl!))
                        //           : const AssetImage("images/avatar.jpg")
                        //               as ImageProvider,
                        //       child: Container(
                        //         child: Align(
                        //           alignment: Alignment.bottomRight,
                        //           child: Container(
                        //             width:
                        //                 MediaQuery.of(context).size.width * 0.1,
                        //             height:
                        //                 MediaQuery.of(context).size.width * 0.1,
                        //             decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(20),
                        //                 color: Colors.grey[300]),
                        //             child: const Icon(
                        //               Icons.camera_alt,
                        //               size: 24,
                        //               color: Colors.black,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ]),
                        // ),
                        ProfileImagePicker(),

                        SizedBox(height: screenHeight * 0.02),
                        Text(userName, style: AppWidget.Headline()),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: cardMargin),
                    child: ListTile(
                      leading:
                          Icon(Icons.account_circle, color: AppColor.lightGrey),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: AppColor.lightGrey),
                      title: Text('Profile', style: AppWidget.TextFieldStyle()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: cardMargin),
                    child: ListTile(
                      leading: Icon(Icons.settings, color: AppColor.lightGrey),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: AppColor.lightGrey),
                      title:
                          Text('Settings', style: AppWidget.TextFieldStyle()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: cardMargin),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: AppColor.lightGrey),
                      leading:
                          Icon(Icons.help_outlined, color: AppColor.lightGrey),
                      title:
                          Text('About us', style: AppWidget.TextFieldStyle()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutUsPage()));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: cardMargin),
                    child: ListTile(
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: AppColor.lightGrey),
                      leading: Icon(Icons.email, color: AppColor.lightGrey),
                      title:
                          Text('Contact us', style: AppWidget.TextFieldStyle()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactUsPage()));
                      },
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: cardMargin),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text('Log Out', style: AppWidget.TextFieldStyle()),
                      onTap: () {
                        _logout(context);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
