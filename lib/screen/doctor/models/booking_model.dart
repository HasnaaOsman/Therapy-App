import 'package:therapy/screen/doctor/models/doctor_model.dart';

class Booking {
  final String id;
  final String doctorId;
  final String userId;
  final String date;
  final String time;
  final Doctor? doctor; // إضافة بيانات الطبيب

  Booking({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.date,
    required this.time,
    this.doctor,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      id: id,
      doctorId: data['doctorId'],
      userId: data['userId'],
      date: data['date'],
      time: data['time'],
      doctor: data['doctor'] != null
          ? Doctor.fromMap(data['doctorId'], data['doctor'])
          : null, // تحويل بيانات الطبيب إذا كانت موجودة
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "doctorId": doctorId,
      "userId": userId,
      "date": date,
      "time": time,
      "doctor": doctor?.toMap(), // تحويل بيانات الطبيب إلى Map
    };
  }
}