import 'package:flutter/material.dart';
import 'package:therapy/screen/book/pages/categories.dart';
import 'package:therapy/screen/doctor/screens/doctor_list.dart';
import 'package:therapy/screen/home/pages/home.dart';
import 'package:therapy/screen/profile/pages/profile.dart';
import 'package:therapy/screen/video/page/video.dart';

import 'bottom_nav_bar.dart'; // استيراد شريط التنقل

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // الحفاظ على الصفحة الحالية

  // قائمة الصفحات
  final List<Widget> _pages = [
    CategoriesScreen(),
    DoctorsListScreen(),
    // CategoriesScreen(),
    const Home(),
    VideosPage(),
    ProfilePage(),
  ];

  // تحديث الصفحة عند اختيار أيقونة
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // عرض الصفحة بناءً على الاختيار
      bottomNavigationBar: CustomBottomNavBar(
          onTap: _onItemTapped, selectedIndex: _selectedIndex),
    );
  }
}
