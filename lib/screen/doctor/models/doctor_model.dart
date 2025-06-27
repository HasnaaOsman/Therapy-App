class Doctor {
  final String id;
  final String name;
  // final String profession;
  final String description;
  final String phone;
  final String imagePath;
  final String locationUrl;

  Doctor({
    required this.id,
    required this.name,
    //required this.profession,
    required this.description,
    required this.phone,
    required this.imagePath,
    required this.locationUrl,
  });

  factory Doctor.fromMap(String id, Map<String, dynamic> data) {
    return Doctor(
      id: id,
      name: data['name'],
      //  profession: data['profession'],
      description: data['description'],
      phone: data['phone'],
      imagePath: data['imagePath'],
      locationUrl: data['locationUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      //"profession": profession,
      "description": description,
      "phone": phone,
      "imagePath": imagePath,
      "locationUrl": locationUrl,
    };
  }
}





// class Doctor {
//   final String id;
//   final String name;
//   final String specialty;
//   final String description;
//   final String imagePath;
//   final String locationUrl;
//   final String phone;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.specialty,
//     required this.description,
//     required this.imagePath,
//     required this.locationUrl,
//     required this.phone,
//   });

//   factory Doctor.fromMap(Map<String, dynamic> data, String id) {
//     return Doctor(
//       id: id,
//       name: data['name'],
//       specialty: data['specialty'],
//       description: data['description'],
//       imagePath: data['imagePath'], // مسار الصورة من assets
//       locationUrl: data['locationUrl'], // رابط الموقع
//       phone: data['phone'],
//     );
//   }
// }