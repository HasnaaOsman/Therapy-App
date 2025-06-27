import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/profile/pages/conect_us.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,),),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: 20,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'images/home.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,),),
                const SizedBox(height: 20),
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,),);},
                  child: Text(
                    "AI Therapy: Your Personal Mental Health Assistant",
                    style: AppWidget.Headline(),
                    textAlign: TextAlign.center,),),
                const SizedBox(height: 8),
                Text(
                  "AI Therapy helps individuals who feel uncomfortable or unable to visit a therapist. Our AI-powered chat provides a professional diagnosis and treatment suggestions.",
                  style: AppWidget.LLightTextFieldStyle(),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 20),
                _buildFeatureItem(
                  icon: Icons.chat_rounded,
                  title: "AI-Powered Chat",
                  description:
                      "Chat with our AI to describe your symptoms and receive professional feedback.",
                  delay: 400,),
                _buildFeatureItem(
                  icon: Icons.health_and_safety,
                  title: "Accurate Diagnosis",
                  description:
                      "Get an expert-level preliminary diagnosis based on your symptoms.",
                  delay: 600,),
                _buildFeatureItem(
                  icon: Icons.verified_user,
                  title: "Confidential & Secure",
                  description:
                      "Your privacy is our priority. Conversations are encrypted and anonymous.",
                  delay: 800,),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsPage()));},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),),
                    shadowColor: Colors.black26,
                    elevation: 5,),
                  child: Text(
                    "Contact Us",
                    style: AppWidget.BBoldTextStyle()
                        .copyWith(color: Colors.white),),),],),),),),);
  }

  // عنصر لكل ميزة مع تأثير Fade In
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * -20, 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.lightGrey, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppWidget.BBoldTextStyle()),
                  const SizedBox(height: 5),
                  Text(description, style: AppWidget.LLightTextFieldStyle()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
