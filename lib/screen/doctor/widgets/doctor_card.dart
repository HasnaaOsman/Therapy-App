import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/doctor/models/doctor_model.dart';
import 'package:therapy/screen/doctor/screens/doctor_details.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  final List<Map<String, String>> days = [
    {"day": "Mon", "date": "16"},
    {"day": "Tue", "date": "17"},
    {"day": "Wed", "date": "18"},
    {"day": "Thu", "date": "19"},
    {"day": "Fri", "date": "20"},
    {"day": "Sat", "date": "21"},
    {"day": "Sun", "date": "22"},
  ];

  DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(
              doctor: doctor,),),);},
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: 350,
          height: 280,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        doctor.name,
                        style: AppWidget.Doctor(),
                        maxLines: 3,
                        overflow: TextOverflow.visible,),),
                    Column(
                      children: [
                        Text(
                          "Book Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DoctorDetailsScreen(doctor: doctor),),);},
                            icon: Icon(Icons.calendar_month_rounded,
                                color: AppColor.blue),),),],),],),),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(doctor.imagePath),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(20),),),),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 207, 224, 253),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.map((day) {
                    bool isSelected = day["date"] == "16";
                    return Container(
                      width: 40,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.blue : Colors.white,
                        borderRadius: BorderRadius.circular(15),),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day["day"]!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,),),
                          const SizedBox(height: 5),
                          Text(
                            day["date"]!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,),),],),);}).toList(),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
