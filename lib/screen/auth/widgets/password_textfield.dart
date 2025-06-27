import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const PasswordTextField(
      {super.key, required this.controller, required this.labelText});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  String? password;
  GlobalKey<FormState> formstate = GlobalKey();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: formstate,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: widget.controller,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password cannot be empty';
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                return 'Password must contain at least one lowercase letter';
              } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter';
              } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                return 'Password must contain at least one number';
              } else if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
                return 'Password must contain at least one special character';
              }
              return null;
            },
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.labelText,
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
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.lightGrey,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
