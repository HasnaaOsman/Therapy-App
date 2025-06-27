import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';
import 'package:therapy/screen/doctor/screens/booking.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  // فتح رابط Google Maps
  Future<void> _launchMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // الاتصال برقم الطبيب
  void _callNumber(String phone) async {
    final Uri callUri = Uri.parse('tel:$phone');
    await launchUrl(callUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(doctor.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: screenWidth * 0.25,
                child: Image.asset(
                  doctor.imagePath,
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildSectionTitle("Name", screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionContent(doctor.name, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildSectionTitle("Description", screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionContent(doctor.description, screenWidth),
              SizedBox(height: screenHeight * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCustomButton(
                    icon: Icons.call,
                    color: AppColor.blue,
                    label: "Call",
                    onTap: () => _callNumber(doctor.phone),
                    size: screenWidth * 0.15,
                  ),
                  _buildCustomButton(
                    icon: Icons.location_on,
                    color: Colors.green[400]!,
                    label: "Location",
                    onTap: () => _launchMap(doctor.locationUrl),
                    size: screenWidth * 0.15,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.06),
              CustomButton(
                text: "Book Appointment",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(doctor: doctor),
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: عنوان القسم
  Widget _buildSectionTitle(String title, double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppWidget.Doctor().copyWith(
          fontSize: screenWidth * 0.045, // حجم متغير حسب الشاشة
        ),
      ),
    );
  }

  /// Widget: محتوى القسم
  Widget _buildSectionContent(String content, double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        content,
        style: AppWidget.DoctorStyle().copyWith(
          fontSize: screenWidth * 0.04, // حجم متغير حسب الشاشة
        ),
      ),
    );
  }

  /// Widget: زر مخصص للأيقونات
  Widget _buildCustomButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    required double size,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: color, size: size * 0.5),
            ),
          ),
        ),
        SizedBox(height: size * 0.15),
        Text(
          label,
          style: AppWidget.BoldTextStyle().copyWith(
            fontSize: size * 0.25, // حجم متغير حسب الشاشة
          ),
        ),
      ],
    );
  }
}
