import 'package:flutter/material.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/book/pages/language.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LanguageScreen(category: title),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.85,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFffffff), // اللون الأساسي الغامق
              Color(0xFFffffff), // اللون الأساسي الغامق
              Color(0xFFffffff), // اللون الأساسي الغامق
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Image.asset(
                image,
                width: 110,
                height: 110,
                // fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppWidget.Doctor()),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: SingleChildScrollView(
                          child: Text(description,
                              style: AppWidget.LightTextFieldStyle()),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Icon(Icons.arrow_forward_ios,
            //       size: 20, color: Colors.white70),
            // ),
          ],
        ),
      ),
    );
  }
}
