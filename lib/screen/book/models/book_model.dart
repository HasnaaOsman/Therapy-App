class Book {
  final String title;
  final String author; 
  final String description; 
  final String assetPath;
  final String category;
  final String language;
  final String imagePath;
  final double rating; // ✅ إضافة التقييم
  final int reviews; // ✅ إضافة عدد المراجعات

  Book({
    required this.title,
    required this.author, 
    required this.description, 
    required this.assetPath,
    required this.category,
    required this.language,
    required this.imagePath,
    required this.rating, // ✅ تمرير التقييم
    required this.reviews, // ✅ تمرير عدد المراجعات
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author, 
      'description': description, 
      'assetPath': assetPath,
      'category': category,
      'language': language,
      'imagePath': imagePath,
      'rating': rating, // ✅ إضافة التقييم
      'reviews': reviews, // ✅ إضافة عدد المراجعات
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      author: map['author'] ?? "Unknown", 
      description: map['description'] ?? "No description available.", 
      assetPath: map['assetPath'],
      category: map['category'],
      language: map['language'],
      imagePath: map['imagePath'] ?? "",
      rating: (map['rating'] ?? 0.0).toDouble(), // ✅ تعيين قيمة افتراضية
      reviews: map['reviews'] ?? 0, // ✅ تعيين قيمة افتراضية
    );
  }
}