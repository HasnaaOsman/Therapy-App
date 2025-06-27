import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/forgetpassword.dart';
import 'package:therapy/screen/auth/pages/signup.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/email_textfiled.dart';
import 'package:therapy/screen/auth/widgets/google_button.dart';
import 'package:therapy/screen/auth/widgets/password_textfield.dart';
import 'package:therapy/screen/bottom_navigator/home_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // مؤشر التحميل

  void _showFlushBar(String message, {bool isError = false}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: isError
          ? Icon(Icons.error_rounded, color: Colors.white)
          : Icon(Icons.check_circle_rounded, color: Colors.white),
      backgroundColor: isError ? Colors.red : Colors.green,
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showFlushBar("Please enter email and password", isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _showFlushBar("Login successful!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      _showFlushBar("Login failed: ${e.toString()}", isError: true);
    }
    setState(() => isLoading = false);
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        _showFlushBar("Google Sign-In successful!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      _showFlushBar("Google Sign-In Error: ${e.toString()}", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Login', style: AppWidget.Headline()),
              SizedBox(height: 40),
              Textformfeild(
                hinttext: 'Enter your email',
                mycontroller: emailController,
                text: 'Email',
                icon: Icon(Icons.email, color: AppColor.lightGrey),
                x: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text('Password', style: AppWidget.TextFieldStyle())],
              ),
              PasswordTextField(
                controller: passwordController,
                labelText: "Password",
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPasswordScreen()));
                    },
                    child: Text("Forget Password?",
                        style: AppWidget.LLightTextFieldStyle()),
                  ),
                ],
              ),
              SizedBox(height: 25),
              isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(text: "Login", onPressed: _login),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColor.semiWhite)),
                  Text("  OR Login with  ", style: AppWidget.Light()),
                  Expanded(child: Divider(color: AppColor.semiWhite)),
                ],
              ),
              SizedBox(height: 25),
              GoogleButton(
                  text: 'Login with Google', onPressed: _signInWithGoogle),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account? ",
                      style: AppWidget.BoldTextStyle()),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Sign up", style: AppWidget.BBoldTextStyle()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
