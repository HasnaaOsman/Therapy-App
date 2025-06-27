import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/auth/widgets/password_textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> formstate = GlobalKey();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // عرض رسالة النجاح
  void _showSuccessMessage() {
    Flushbar(
      message: "Password changed successfully! Please log in again.",
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  // عرض رسالة الخطأ
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

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // إعادة المصادقة بالمستخدم
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: oldPasswordController.text,
        );

        await user!.reauthenticateWithCredential(credential);

        // تحديث كلمة المرور
        await user!.updatePassword(newPasswordController.text);

        // عرض رسالة النجاح
        _showSuccessMessage();

        // تأخير التنقل بعد عرض الرسالة
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } catch (e) {
        // عرض رسالة الخطأ
        _showErrorMessage("Something went wrong: $e");
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
          title: Text("Change Password", style: AppWidget.Headline())),
      body: SafeArea(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Current Password',
                          style: AppWidget.TextFieldStyle()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: oldPasswordController,
                    validator: (value) =>
                        value!.isEmpty ? "Enter your current password" : null,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Current Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColor.lightGrey,
                      ),
                      hintStyle: AppWidget.LightTextFieldStyle(),
                      fillColor: AppColor.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.black,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lightGrey),
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColor.lightGrey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('New Password', style: AppWidget.TextFieldStyle()),
                    ],
                  ),
                  PasswordTextField(
                      controller: newPasswordController,
                      labelText: "Enter new password"),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Confirm Password',
                          style: AppWidget.TextFieldStyle()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) => value != newPasswordController.text
                        ? "Passwords do not match"
                        : null,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColor.lightGrey,
                      ),
                      hintStyle: AppWidget.LightTextFieldStyle(),
                      fillColor: AppColor.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.black,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.lightGrey),
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColor.lightGrey,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 56),
                  CustomButton(
                    text: "Save",
                    onPressed: _changePassword,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
