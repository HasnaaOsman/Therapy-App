import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/email_textfiled.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showFlushBar(context, "Please enter your email", Colors.red,
          isError: true);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showFlushBar(
          context, "Check your email to reset your password!", Colors.green,
          isError: false);

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      });
    } catch (e) {
      _showFlushBar(
          context, "Failed to send reset email. Try again.", Colors.red);
    }
  }

  void _showFlushBar(BuildContext context, String message, Color color,
      {bool isError = false}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: isError
          ? Icon(Icons.error_rounded, color: Colors.white)
          : Icon(Icons.check_circle_rounded, color: Colors.white),
      backgroundColor: color,
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Forget Password",
          style: AppWidget.Headline(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Don’t worry! It happens. Please enter the email associated with your account.',
                  style: AppWidget.Black(),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 25),
                CustomButton(
                  text: "Send Reset Link",
                  onPressed: () => _resetPassword(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
