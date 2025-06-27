import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/book/data/book_data.dart';
import 'package:therapy/screen/book/models/book_model.dart';
import 'package:therapy/screen/book/services/favourite_services.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(book.title,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05)),
      ),
      body: PDF(
        enableSwipe: true,
        autoSpacing: false,
        pageFling: false,
        backgroundColor: Colors.white,
        onError: (error) => print(error.toString()),
        onPageError: (page, error) => print('$page: ${error.toString()}'),
      ).fromAsset(book.assetPath),
    );
  }
}

class BooksScreen extends StatefulWidget {
  final String category;
  final String language;
  const BooksScreen(
      {super.key, required this.category, required this.language});
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<String> favoriteBooks = [];
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    favoriteBooks = await FavoritesService.getFavorites();
    setState(() {});
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: [
        ...List.generate(fullStars,
            (index) => Icon(Icons.star, color: Colors.amber, size: 18)),
        if (hasHalfStar) Icon(Icons.star_half, color: Colors.amber, size: 18),
        ...List.generate(5 - fullStars - (hasHalfStar ? 1 : 0),
            (index) => Icon(Icons.star_border, color: Colors.amber, size: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.18;
    double fontSize = screenWidth < 350 ? 14 : 16;
    final filteredBooks = books
        .where((book) =>
            book.category == widget.category &&
            book.language == widget.language)
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Books",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Padding نسبي
        child: ListView.builder(
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            bool isFavorite = favoriteBooks.contains(book.title);
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookDetailScreen(book: book))),
              child: Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          book.imagePath,
                          width: imageSize,
                          height: imageSize * 1.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bestseller",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize * 0.75)),
                            SizedBox(height: 4),
                            Text(
                              book.title,
                              style: AppWidget.VideoStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              book.author,
                              style: AppWidget.AuthorStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                _buildStarRating(book.rating),
                                SizedBox(width: screenWidth * 0.02),
                                Flexible(
                                  child: Text(
                                    "${book.reviews} Reviews",
                                    style: AppWidget.AuthorStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.grey),
                        onPressed: () async {
                          if (isFavorite) {
                            await FavoritesService.removeFavorite(book.title);
                            Flushbar(
                              message: "${book.title} removed from favorites.",
                              duration: Duration(seconds: 2),
                              margin: EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: Colors.red,
                              icon: Icon(Icons.delete, color: Colors.white),
                            ).show(context);
                          } else {
                            await FavoritesService.addFavorite(book.title);
                            Flushbar(
                              message: "${book.title} added to favorites.",
                              duration: Duration(seconds: 2),
                              margin: EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: Colors.green,
                              icon: Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                            ).show(context);
                          }
                          _loadFavorites();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
