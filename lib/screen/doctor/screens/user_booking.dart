import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/doctor/models/booking_model.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';
import 'package:therapy/screen/doctor/screens/doctor_list.dart';
import 'package:therapy/screen/doctor/services/fire_services.dart';

import '../widgets/booking_card.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  _UserBookingsScreenState createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Booking>> _bookingsFuture;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      _bookingsFuture = _firebaseService.getUserBookings(_userId!);
    }
  }

  void _showCancelDialog(BuildContext context, String bookingId) async {
    bool confirmCancel = await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Are you sure you want to cancel this booking?",
                      textAlign: TextAlign.center,
                      style: AppWidget.GoogleStyle()),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                              right: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;

    if (confirmCancel) {
      try {
        await _firebaseService.cancelBooking(bookingId);

        if (context.mounted) {
          setState(() {
            _bookingsFuture = _firebaseService.getUserBookings(_userId!);
          });

          Flushbar(
            message: "Booking cancelled successfully",
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
            icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.BOTTOM,
          ).show(context);
        }
      } catch (e) {
        if (context.mounted) {
          Flushbar(
            message: "Failed to cancel booking. Please try again.",
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
            icon: const Icon(Icons.error_outline, color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            flushbarPosition: FlushbarPosition.BOTTOM,
          ).show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "My Appointments",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: _userId == null
            ? const Center(child: Text("Please log in"))
            : FutureBuilder<List<Booking>>(
                future: _bookingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching bookings"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          width: 200,
                          height: 200,
                          "images/empty.png",
                        ),
                        Text("No bookings available , Book Now",
                            style: AppWidget.DateStyle()),
                      ],
                    ));
                  }

                  List<Booking> bookings = snapshot.data!;

                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      Booking booking = bookings[index];

                      return FutureBuilder<Doctor?>(
                        future:
                            _firebaseService.getDoctorById(booking.doctorId),
                        builder: (context, doctorSnapshot) {
                          if (doctorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (doctorSnapshot.hasError ||
                              !doctorSnapshot.hasData) {
                            return const Center(
                                child: Text("Error loading doctor details"));
                          }

                          Doctor doctor = doctorSnapshot.data!;

                          return BookingCard(
                            booking: booking,
                            doctor: doctor,
                            onCancel: () {
                              _showCancelDialog(context, booking.id);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

        // ✅ زر الحجز العائم
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: FloatingActionButton(
            backgroundColor: AppColor.blue,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorsListScreen()),
            ),
            child: Icon(Icons.calendar_month, color: Colors.white),
          ),
        ));
  }
}
