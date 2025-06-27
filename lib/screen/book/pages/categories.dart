import 'package:flutter/material.dart';
import 'package:therapy/screen/book/data/category_data.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Categories",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Colors.black), // تخصيص لون الأيقونات في الـ AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CategoriesList(), 
        // استدعاء القائمة هنا
      ),
    );
  }
}
