import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  // دالة لفتح تطبيق الهاتف عند الضغط على الرقم
  void _callNumber(String number) async {
    final Uri callUri = Uri.parse('tel:$number');
    await launchUrl(callUri, mode: LaunchMode.externalApplication);
  }

  // دالة لإرسال بريد إلكتروني
  void _sendEmail(String email) async {
    final Uri emailUri = Uri.parse('mailto:$email?subject=Support Request');
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  // دالة لفتح محادثة واتساب مع الرقم
  void _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Contact us",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.1),
              _buildContactTile(
                context,
                icon: Icons.email,
                title: "Call Us",
                subtitle: "+201016152170",
                color: Colors.blueAccent,
                onTap: () => _callNumber("+201016152170"),
                imageAsset: "images/phone.png", ),
              _buildContactTile(
                context,
                icon: Icons.email,
                title: "Email Us",
                subtitle: "therapyai@gmail.com",
                color: Colors.redAccent,
                onTap: () => _sendEmail("hasnaaosman170@gmail.com"),
                imageAsset: "images/gmail.png", ),
              _buildContactTile(
                context,
                icon: Icons.chat,
                title: "WhatsApp",
                subtitle: "+201016152170",
                color: Colors.green,
                onTap: () => _openWhatsApp("201016152170"),
                imageAsset: "images/whatsapp.png",),],),),),);
  }

  Widget _buildContactTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required VoidCallback onTap,
      String? imageAsset}) {
    // إضافة الخاصية imageAsset
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: imageAsset != null
            ? Image.asset(imageAsset,
                width: screenWidth * 0.08, height: screenWidth * 0.08)
            : Icon(icon, color: color, size: screenWidth * 0.08),
        title: Text(title,
            style: TextStyle(
                fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: TextStyle(
                fontSize: screenWidth * 0.04, color: Colors.grey[600])),
        onTap: onTap,
      ),
    );
  }
}
