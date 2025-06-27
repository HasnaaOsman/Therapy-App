import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/book/data/book_data.dart';
import 'package:therapy/screen/book/models/book_model.dart';
import 'package:therapy/screen/book/pages/book.dart';
import 'package:therapy/screen/book/pages/categories.dart';
import 'package:therapy/screen/book/services/favourite_services.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // تحميل الكتب المفضلة من الخدمة
  void _loadFavorites() async {
    favoriteBooks = await FavoritesService.getFavorites();
    setState(() {});
  }

  // نافذة تأكيد حذف الكتاب من المفضلة
  void _showDeleteConfirmation(
      BuildContext context, String bookTitle, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
                Text(
                    "Are you sure you want to remove \"$bookTitle\" from your favorites?",
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
                          onPressed: () async {
                            await FavoritesService.removeFavorite(bookTitle);
                            setState(() {
                              favoriteBooks.removeAt(index);
                            });
                            Navigator.of(context).pop();

                            // ✅ إظهار Flushbar بعد الحذف
                            Flushbar(
                              message: "\"$bookTitle\" removed from favorites.",
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(8),
                              icon: const Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                            ).show(context);
                          },
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
                          onPressed: () => Navigator.pop(context),
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
        );
      },
    );
  }

  // أداة عرض التقييم كنجمات
  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: [
        ...List.generate(fullStars,
            (index) => const Icon(Icons.star, color: Colors.amber, size: 20)),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.amber, size: 20),
        ...List.generate(
            5 - fullStars - (hasHalfStar ? 1 : 0),
            (index) =>
                const Icon(Icons.star_border, color: Colors.amber, size: 20)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Favorites",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          elevation: 0,),
        body: favoriteBooks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/empty.png",
                      width: 200,
                      height: 200,),
                    Text(
                      "No favorite books yet , Add Now",
                      style: AppWidget.DateStyle(),),],),)
            : ListView.builder(
                itemCount: favoriteBooks.length,
                itemBuilder: (context, index) {
                  String bookTitle = favoriteBooks[index];
                  Book book = books.firstWhere(
                    (book) => book.title == bookTitle,
                    orElse: () => Book(
                        title: bookTitle,
                        author: "",
                        imagePath: "",
                        rating: 0,
                        description: '',
                        assetPath: '',
                        category: '',
                        language: '',
                        reviews: 5),);
                  return Dismissible(
                    key: Key(bookTitle),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      _showDeleteConfirmation(context, bookTitle, index);
                      return false;},
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child:
                          const Icon(Icons.delete_forever, color: Colors.white),),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(book: book),),);},
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  book.imagePath,
                                  width: 70,
                                  height: 100,
                                  fit: BoxFit.cover,),),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: AppWidget.VideoStyle(),
                                      overflow: TextOverflow.ellipsis,),
                                    const SizedBox(height: 6),
                                    Text(
                                      book.author,
                                      style: AppWidget.AuthorStyle(),),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        _buildStarRating(book.rating),
                                        const SizedBox(width: 16),
                                        Text(
                                          "${book.reviews} Reviews",
                                          style: AppWidget.AuthorStyle(),),],),],),),],),),),),);},),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: FloatingActionButton(
            backgroundColor: AppColor.blue,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),),
            child: Icon(Icons.menu_book_rounded, color: Colors.white),),));
  }
}
