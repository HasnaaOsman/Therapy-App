import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';
import 'package:therapy/screen/doctor/services/fire_services.dart';

import '../widgets/doctor_card.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  _DoctorsListScreenState createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Doctor>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture =
        _firebaseService.getDoctors(); // ✅ الآن لا يمكن أن يرجع null
  }

  void _showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      message: message,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Doctors List",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<Doctor>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorFlushbar(context, "Error fetching doctors");
            });
            return const Center(child: Text("Error fetching doctors"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No doctors available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
