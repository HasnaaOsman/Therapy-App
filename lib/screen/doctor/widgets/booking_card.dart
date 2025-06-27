import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/doctor/models/booking_model.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final Doctor doctor;
  final VoidCallback onCancel;

  const BookingCard({
    required this.booking,
    required this.doctor,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),),],),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColor.blue.withOpacity(0.1),
            backgroundImage: AssetImage(doctor.imagePath),
            onBackgroundImageError: (_, __) {},
            child: doctor.imagePath.isEmpty
                ? Icon(Icons.person, size: 32, color: AppColor.blue)
                : null,),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Appointment with ${doctor.name}",
                    style: AppWidget.VideoStyle()),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text("🗓 ", style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.date,
                              style: AppWidget.TimeStyle(),
                              overflow: TextOverflow
                                  .ellipsis,),),],),),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          const Text("⏰ ", style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.time,
                              style: AppWidget.TimeStyle(),
                              overflow: TextOverflow.ellipsis,),),],),),],),],),),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,),
              onPressed: onCancel,),),],),);}}
