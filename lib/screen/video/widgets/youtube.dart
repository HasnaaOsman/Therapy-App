import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeThumbnail extends StatelessWidget {
  final String videoUrl;

  const YoutubeThumbnail({super.key, required this.videoUrl});

  String getThumbnailUrl() {
    // استخراج الـ videoId من الرابط
    Uri uri = Uri.parse(videoUrl);
    String? videoId = uri.queryParameters["v"] ?? uri.pathSegments.last;
    return "https://img.youtube.com/vi/$videoId/0.jpg"; // صورة الفيديو
  }

  void _launchURL() async {
    final Uri url = Uri.parse(videoUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              getThumbnailUrl(),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 40)),
              ),
            ),
            Image.asset(
              "images/YouTube.png",
            ),
          ],
        ),
      ),
    );
  }
}
