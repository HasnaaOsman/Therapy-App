import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  static final CollectionReference _favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');

  // جلب معرف المستخدم الحقيقي
  static String getUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
  }

  // التأكد من أن المستند موجود قبل استخدامه
  static Future<void> initializeUserFavorites() async {
    final docRef = _favoritesCollection.doc(getUserId());
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({'books': []}); // إنشاء المستند بحقل 'books'
    }
  }

  // جلب قائمة الكتب المفضلة
  static Future<List<String>> getFavorites() async {
    await initializeUserFavorites();
    final snapshot = await _favoritesCollection.doc(getUserId()).get();

    final data = snapshot.data() as Map<String, dynamic>?; // تحويل Object إلى Map
    return List<String>.from(data?['books'] ?? []);
  }

  // إضافة كتاب إلى المفضلة
  static Future<void> addFavorite(String book) async {
    await initializeUserFavorites();
    final favorites = await getFavorites();
    if (!favorites.contains(book)) {
      favorites.add(book);
      await _favoritesCollection.doc(getUserId()).set({'books': favorites});
    }
  }

  // إزالة كتاب من المفضلة
  static Future<void> removeFavorite(String book) async {
    await initializeUserFavorites();
    final favorites = await getFavorites();
    favorites.remove(book);
    await _favoritesCollection.doc(getUserId()).set({'books': favorites});
  }
}