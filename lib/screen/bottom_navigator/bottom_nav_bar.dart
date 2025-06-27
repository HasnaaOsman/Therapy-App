import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth * 0.07; // أيقونات متناسبة مع الشاشة
    double navBarHeight = screenWidth * 0.13; // ارتفاع الناف بار
    double floatingButtonSize = screenWidth * 0.16; // حجم زر الهوم بعد التعديل

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: navBarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.08),
            //     blurRadius: 10,
            //     offset: const Offset(0, -3),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.menu_book_rounded, 0, iconSize),
              _buildNavItem(Icons.calendar_month_rounded, 1, iconSize),
              const SizedBox(
                  width: 40), // زيادة المسافة بين الأيقونات وزر الهوم
              _buildNavItem(Icons.video_collection_rounded, 3, iconSize),
              _buildNavItem(Icons.person_3_rounded, 4, iconSize),
            ],
          ),
        ),
        Positioned(
          top: -(floatingButtonSize * 0.5), // ضبط التداخل ليكون أكثر تناسقًا
          left: screenWidth / 2 - floatingButtonSize / 2,
          child: _buildCenterButton(2, floatingButtonSize),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, int index, double size) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        color: isSelected ? AppColor.blue : AppColor.darkGrey,
        size: size,
      ),
    );
  }

  Widget _buildCenterButton(int index, double size) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: AppColor.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          Icons.home_rounded,
          color: Colors.white,
          size: size * 0.42,
        ),
      ),
    );
  }
}
