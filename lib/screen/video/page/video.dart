import 'package:flutter/material.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/video/widgets/youtube.dart';

class VideosPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      "title":
          "Opens Up About Anxiety, Insecurity, & How To Be Truly Happy! | Jay Shetty",
      "url": "https://youtu.be/ZjIRYn7x8sk?si=UQlTpeKLplN7pNa5",
    },
    {
      "title": "Change Your Brain, Change Your Life",
      "url": "https://youtu.be/0SPC_Q7-k40?si=XtoxWW_rV-3-6y0z",
    },
    {
      "title": "Mental health and young people",
      "url": "https://youtu.be/01wcrrAYrpM?si=d1wEUnxfEYQWUiJB",
    },
    {
      "title":
          "The Mental Health Doctor: Your Phone Screen & Sitting Is Destroying Your Brain!",
      "url": "https://youtu.be/FN0_ow76hU8?si=uZyYHdnxj4GCOjPM",
    },
    {
      "title": "NEW Mental Health Podcast",
      "url": "https://www.youtube.com/live/y2LDE33FaNk?si=AdgxkD3LBQ_oItnP",
    },
    {
      "title": "How To Detach From Overthinking & Anxiety",
      "url": "https://youtu.be/iLlrIi9-NfQ?si=Ji_NqNL5Bl62CQgZ",
    },
    {
      "title": "The Science & Treatment of Obsessive Compulsive Disorder (OCD)",
      "url": "https://youtu.be/OadokY8fcAA?si=YxLHPxhPbJqD-8oQ",
    },
    {
      "title": "OCD explained for beginners - how I wish I was taught",
      "url": "https://youtu.be/iXnVjqeAzP4?si=IzxvqOvposo5WpF_",
    },
    {
      "title":
          "How to Release Obsessive Thoughts: Rumination, OCD, and Fear | Being Well Podcast",
      "url": "https://youtu.be/CvUE56WzxJU?si=j5Kd0qANWX8-4EmU",
    },
    {
      "title":
          "Bipolar Disorder Food: Mediterranean & Time-Restricted Eating | Dr. Sheri Johnson",
      "url": "https://youtu.be/LPnIyc8x5B0?si=0QynQlli8KeUBiwA",
    },
    {
      "title": "10 Ways to HELP Someone With BIPOLAR DISORDER",
      "url": "https://youtu.be/qEk0qwCK_no?si=zXB6SLeiWXYTExT5",
    },
    {
      "title": "3 Proven Methods to Heal Trauma and Rewire Your Nervous System",
      "url": "https://youtu.be/etmtcooHY_g?si=FaEfJRumwE4MhkF0",
    },
    {
      "title":
          "Dr. Paul Conti: Therapy, Treating Trauma & Other Life Challenges",
      "url": "https://youtu.be/IOl28gj_RXw?si=QbotLzBnHEnh-vLV",
    },
    {
      "title":
          "How To FACE & HEAL The TRAUMA That Dictates Your Life: Paul Conti, MD",
      "url": "https://youtu.be/9PKcDj4eQ7I?si=NP2LoCSlCsN5TBln",
    },
    {
      "title":
          "Leading Childhood Trauma Doctor: 10 Lies They Told You About Your Childhood Trauma! - Paul Conti",
      "url": "https://youtu.be/USE89i0kiiQ?si=AbT_Zb1x4DnqPulo",
    },
    {
      "title": "The TRUTH About ADHD in Adults",
      "url": "https://youtu.be/0R0xhDNPfwU?si=h4vbbkq8c2_6nmEm",
    },
    {
      "title": "ADHD & How Anyone Can Improve Their Focus",
      "url": "https://youtu.be/hFL6qRIJZ_Y?si=ceCWBFoDNeLHKdoN",
    },
    {
      "title":
          "Dr. Gabor Maté: The Shocking Link Between ADHD, Addiction, Autoimmune Diseases, & Trauma",
      "url": "https://youtu.be/PLvCXIvgrGQ?si=bX61RTlLjcK9SA9x",
    },
  ];

  VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          " Videos",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YoutubeThumbnail(videoUrl: videos[index]["url"]!),
                    const SizedBox(height: 8),
                    Text(videos[index]["title"]!,
                        style: AppWidget.VideoStyle()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
