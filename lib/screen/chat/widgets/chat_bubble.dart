import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.7, // تحديد العرض الأقصى للفقاعة
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColor.blue : AppColor.Grey,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(20),
            bottomLeft:
                isMe ? const Radius.circular(20) : const Radius.circular(0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe)
              CustomPaint(
                size: Size(10, 20),
                painter: TrianglePainter(),
              ),
            // Allow text to wrap inside the bubble
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
                softWrap: true, // النص سيتنقل للأسطر التالية تلقائيًا
                overflow: TextOverflow
                    .visible, // النص سيظهر بشكل كامل حتى لو تعدد الأسطر
              ),
            ),
            if (isMe)
              CustomPaint(
                size: Size(10, 20),
                painter: TrianglePainter(isMe: isMe),
              ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isMe;

  TrianglePainter({this.isMe = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isMe ? AppColor.blue : Colors.grey[200]!;
    final Path path = Path();
    if (isMe) {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
