import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';

class GoogleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.lightGrey),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/Google.png",
          ),
          const SizedBox(
            width: 10,
          ),
          Text(text, style: AppWidget.GoogleStyle())
        ],
      ),
    );
  }
}
