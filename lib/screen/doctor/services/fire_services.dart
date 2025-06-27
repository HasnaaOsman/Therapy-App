import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:therapy/screen/doctor/models/booking_model.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة أطباء إلى Firestore
  Future<void> addDoctors() async {
    List<Map<String, dynamic>> doctors = [
      {
        "name": "Dr. John Doe",
        "profession": "Psychologist",
        "description": "Specialist in mental health therapy.",
        "imageUrl": "https://example.com/doctor1.jpg",
        "locationUrl": "https://maps.google.com/?q=clinic1",
      },
      {
        "name": "Dr. Sarah Smith",
        "profession": "Therapist",
        "description": "Expert in cognitive behavioral therapy.",
        "imageUrl": "https://example.com/doctor2.jpg",
        "locationUrl": "https://maps.google.com/?q=clinic2",
      },
    ];

    for (var doctor in doctors) {
      await _firestore.collection('doctors').doc().set(doctor);
    }
  }

  /// جلب قائمة الأطباء من Firestore
  Future<List<Doctor>> getDoctors() async {
    QuerySnapshot snapshot = await _firestore.collection('doctors').get();
    return snapshot.docs
        .map(
            (doc) => Doctor.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// جلب بيانات طبيب معين باستخدام الـ doctorId
  Future<Doctor?> getDoctorById(String doctorId) async {
    DocumentSnapshot doc =
        await _firestore.collection('doctors').doc(doctorId).get();

    if (doc.exists) {
      return Doctor.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } else {
      return null; // في حالة عدم العثور على الطبيب
    }
  }

  /// حجز موعد
  Future<void> bookAppointment(
      String doctorId, String userId, String date, String time) async {
    DocumentReference bookingRef = _firestore.collection('bookings').doc();
    await bookingRef.set({
      "doctorId": doctorId,
      "userId": userId,
      "date": date,
      "time": time,
    });
  }

  /// جلب الحجوزات الخاصة بالمستخدم
  Future<List<Booking>> getUserBookings(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) =>
            Booking.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// إلغاء الحجز
  Future<void> cancelBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }
}
