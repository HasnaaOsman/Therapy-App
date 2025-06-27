import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';

class GuidelinesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guidelines',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Welcome to the AI Chat ',
                    style: AppWidget.Headline(),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You can freely share your thoughts, and the AI will respond accordingly.',
                  style: AppWidget.AuthorStyle(),
                ),
                SizedBox(height: 10),
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 10),
                Text(
                  'For a quick classification of your conversation:',
                  style: AppWidget.GoogleStyle(),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.text_fields_rounded, color: AppColor.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Type the exact phrase',
                            style: AppWidget.DoctorStyle(),
                          ),
                          Center(
                            child: Text(
                              '"diagnose me"',
                              style: TextStyle(
                                  color: AppColor.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Divider(thickness: 1, color: Colors.grey[300]),
                // SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.rule_outlined, color: AppColor.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rules',
                        style: AppWidget.GoogleStyle(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Make sure it is written exactly as shown, with no capital letters.',
                        style: AppWidget.OnboardStyle(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'The AI will then provide a quick classification based on your previous messages.',
                          style: AppWidget.OnboardStyle()),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                //  Spacer(),
                Center(
                  child: CustomButton(
                    text: "Ok",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
