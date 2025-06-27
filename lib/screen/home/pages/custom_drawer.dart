import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/book/pages/favourite.dart';
import 'package:therapy/screen/doctor/screens/user_booking.dart';
import '../../chat/pages/chat_history.dart';

class CustomPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      color: Colors.white, // الخلفية بيضاء
      onSelected: (value) async {
        if (value == 'Favorite') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
          );
        } else if (value == 'Appointment') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserBookingsScreen()),
          );
        } else if (value == 'Chats') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatListScreen()),
          );
        } else if (value == 'Log Out') {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Favorite',
          child: Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.black),
              SizedBox(width: 10),
              Text('Favorite'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Appointment',
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.black),
              SizedBox(width: 10),
              Text('Appointment'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Chats',
          child: Row(
            children: [
              Icon(Icons.chat_outlined, color: Colors.black),
              SizedBox(width: 10),
              Text('Chats'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Log Out',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text('Log Out', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}