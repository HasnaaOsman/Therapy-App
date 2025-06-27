import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/book/pages/book.dart';

class LanguageScreen extends StatefulWidget {
  final String category;
  const LanguageScreen({super.key, required this.category});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selectedLanguage; // لحفظ اللغة المختارة

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth < 350 ? 16 : 18;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Choose Language",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              RadioListTile<String>(
                title: Text(
                  "Arabic",
                  style: AppWidget.Headline(),),
                value: "ar",
                groupValue: selectedLanguage,
                activeColor: AppColor.blue,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;});},),
              RadioListTile<String>(
                title: Text(
                  "English",
                  style: AppWidget.Headline(),),
                value: "en",
                groupValue: selectedLanguage,
                activeColor: AppColor.blue,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;});},),
              SizedBox(height: 56),
              ElevatedButton(
                onPressed: selectedLanguage == null
                    ? null 
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BooksScreen(
                              category: widget.category,
                              language: selectedLanguage!,),),);},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Next", style: AppWidget.BottomStyle()),)],),),),);}
}
