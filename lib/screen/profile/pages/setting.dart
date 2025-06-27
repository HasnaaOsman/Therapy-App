import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/profile/pages/edit/change_password.dart';
import 'package:therapy/screen/profile/pages/edit/edit_email.dart';
import 'package:therapy/screen/profile/pages/edit/edit_profile.dart';

class SettingsPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  SettingsPage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Settings",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: ListView(
            children: [
              Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  trailing:
                      Icon(Icons.arrow_forward_ios, color: AppColor.lightGrey),
                  leading: Icon(Icons.email, color: AppColor.lightGrey),
                  title: Text('Email', style: AppWidget.TextFieldStyle()),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEmailPage()));
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  trailing:
                      Icon(Icons.arrow_forward_ios, color: AppColor.lightGrey),
                  leading: Icon(Icons.lock, color: AppColor.lightGrey),
                  title: Text('Security', style: AppWidget.TextFieldStyle()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()));
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  trailing:
                      Icon(Icons.arrow_forward_ios, color: AppColor.lightGrey),
                  leading:
                      Icon(Icons.update_rounded, color: AppColor.lightGrey),
                  title: Text('Updates', style: AppWidget.TextFieldStyle()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
                  },
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text('Log Out', style: AppWidget.TextFieldStyle()),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
