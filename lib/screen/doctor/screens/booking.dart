import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/widgets/custom_button.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';
import 'package:therapy/screen/doctor/services/fire_services.dart';

class BookingPage extends StatefulWidget {
  final Doctor doctor;

  const BookingPage({required this.doctor, super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirebaseService _firebaseService = FirebaseService();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  /// دالة لاختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.blue, // لون العنوان والتحديد
            colorScheme: ColorScheme.light(primary: AppColor.blue),
            dialogBackgroundColor: Colors.white, // خلفية بيضاء
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.blue, // لون زر OK و Cancel
                textStyle: AppWidget.SkipStyle(), // حجم وخط الزر
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.blue, // لون العنوان والتحديد
            colorScheme: ColorScheme.light(primary: AppColor.blue),
            dialogBackgroundColor: Colors.white, // خلفية بيضاء
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: Colors.blue[100], // 🔵 لون AM/PM أزرق فقط
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.blue, // لون زر OK و Cancel
                textStyle: AppWidget.SkipStyle(),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  /// دالة لحجز الموعد
  void _bookAppointment() async {
    if (selectedDate != null && selectedTime != null) {
      String formattedDate =
          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
      String formattedTime = selectedTime!.format(context);

      // الحصول على الـ userId من Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // حجز الموعد
      await _firebaseService.bookAppointment(
        widget.doctor.id,
        userId,
        formattedDate,
        formattedTime,
      );

      Future.delayed(Duration.zero, () {
        _showFlushbar(
          context,
          message: "Appointment booked successfully!",
          color: Colors.green,
          icon: Icons.check_circle,
        );
      });

      // العودة إلى الصفحة بعد 2 ثانية
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      Future.delayed(Duration.zero, () {
        _showFlushbar(
          context,
          message: "Please select a date and time",
          color: Colors.red,
          icon: Icons.error,
        );
      });
    }
  }

  /// دالة لإظهار رسائل الفلاش بار
  void _showFlushbar(BuildContext context,
      {required String message, required Color color, required IconData icon}) {
    Flushbar(
      message: message,
      icon: Icon(icon, size: 28, color: Colors.white),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: color,
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Book Appointment",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.white,),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectionTile(
              title: "Select Date",
              value: selectedDate == null
                  ? "No date selected"
                  : DateFormat("EEEE, MMM d, yyyy").format(selectedDate!),
              icon: Icons.calendar_today,
              onTap: () => _selectDate(context),),
            SizedBox(height: screenHeight * 0.03),
            _buildSelectionTile(
              title: "Select Time",
              value: selectedTime == null
                  ? "No time selected"
                  : selectedTime!.format(context),
              icon: Icons.access_time,
              onTap: () => _selectTime(context),),
            SizedBox(height: screenHeight * 0.07),
            Center(
              child: CustomButton(
                text: "Confirm Booking",
                onPressed: _bookAppointment,),),],),),);}
  Widget _buildSelectionTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xffF979797)),),
      tileColor: Colors.grey.shade100,
      leading: Icon(icon, color: AppColor.blue, size: 30),
      title: Text(title, style: AppWidget.DateStyle()),
      subtitle: Text(
        value,
        style: AppWidget.DateHint(),),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,);}}
