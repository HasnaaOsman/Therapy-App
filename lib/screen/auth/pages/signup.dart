import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/email_textfiled.dart';
import 'package:therapy/screen/auth/widgets/google_button.dart';
import 'package:therapy/screen/auth/widgets/password_textfield.dart';
import 'package:therapy/screen/auth/widgets/phone_field.dart';
import 'package:therapy/screen/auth/widgets/user_field.dart';
import 'package:therapy/screen/bottom_navigator/home_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _signUp() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': usernameController.text,
        'phone': phoneController.text,
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      print("Error: $e");
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      print("User signed out successfully.");

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
        User? user = userCredential.user;

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (!doc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'username': user.displayName ?? 'No Name',
            'email': user.email,
            'photoUrl': user.photoURL,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'username': user.displayName ?? 'No Name',
            'email': user.email,
            'photoUrl': user.photoURL,
          });
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Center(child: Text('Sign Up', style: AppWidget.Headline())),
              const SizedBox(height: 32),
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
              const SizedBox(height: 24),
              UserField(
                hinttext: 'Enter your name',
                mycontroller: usernameController,
                text: 'Username',
                icon: Icon(
                  Icons.person,
                  color: AppColor.lightGrey,
                ),
                x: TextInputType.name,
              ),
              const SizedBox(height: 24),
              PhoneField(
                hinttext: '000 000 0000',
                mycontroller: phoneController,
                text: 'Phone',
                icon: Icon(
                  Icons.phone,
                  color: AppColor.lightGrey,
                ),
                x: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: AppWidget.TextFieldStyle()),
              ),
              PasswordTextField(
                controller: passwordController,
                labelText: "Password",
              ),
              const SizedBox(height: 32),
              CustomButton(text: "Sign Up", onPressed: _signUp),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: AppColor.semiWhite,
                  )),
                  Text("  OR Sign with  ", style: AppWidget.Light()),
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: AppColor.semiWhite,
                  )),
                ],
              ),
              const SizedBox(height: 32),
              GoogleButton(
                  text: 'Sign up with Google', onPressed: _signInWithGoogle),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: AppWidget.BoldTextStyle()),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text("Login", style: AppWidget.BBoldTextStyle()),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
