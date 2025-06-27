import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/chat/pages/chat.dart';
import 'package:therapy/screen/home/pages/custom_drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<String> quotes = [
      "You are stronger than you think, and you're doing your best every day",
      "It's okay to have bad days, What matters is that you keep going.",
      "Your journey is unique, and you're moving forward, even if it's one small step at a time.",
      "You are not alone in this. There are people who care and want to help.",
      "Every day is a new opportunity for healing. Be kind to yourself.",
      "It's okay to take breaks. Healing is a process, and you're making progress.",
      "Your feelings are valid, and it's okay to express them. You deserve compassion.",
      "The fact that you're here, seeking help, shows how much courage you have.",
      "Take things one day at a time. Small steps lead to big changes.",
      "You are worth all the care and love you're giving yourself. Keep believing in yourself.",
    ];

    String randomQuote = (quotes..shuffle()).first;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Speaking to AI Chat",
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            CustomPopupMenu(),
            // PopupMenuButton<String>(
            //   icon: Icon(Icons.more_vert), // الثلاث نقط
            //   onSelected: (value) {
            //     if (value == 'Favorite') {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => FavoritesScreen()));
            //     } else if (value == 'Appointment') {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => UserBookingsScreen()));
            //     } else if (value == 'Chats') {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ChatListScreen()));
            //     } else if (value == 'Log Out') {}
            //   },
            //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            //     PopupMenuItem<String>(
            //       value: 'Favorite',
            //       child: Text('Favorite'),
            //     ),
            //     PopupMenuItem<String>(
            //       value: 'Appointment',
            //       child: Text('Appointment'),
            //     ),
            //     PopupMenuItem<String>(
            //       value: 'Chats',
            //       child: Text('Chats'),
            //     ),
            //     PopupMenuItem<String>(
            //       value: 'Log Out',
            //       child: Text('Log Out', style: TextStyle(color: Colors.red)),
            //     ),
            //   ],
            // ),
          ],
        ),
        //  drawer: MenuDropdownPage(), //
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Lottie.asset(
                  'images/home.json',
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.4,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(randomQuote,
                      textAlign: TextAlign.center,
                      style: AppWidget.SkipStyle()),
                ),
                SizedBox(height: screenHeight * 0.1),
                AnimatedGradientButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedGradientButton extends StatefulWidget {
  final VoidCallback onTap;
  const AnimatedGradientButton({super.key, required this.onTap});

  @override
  _AnimatedGradientButtonState createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _alignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 327,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: _alignmentAnimation.value,
                end: Alignment.centerRight,
                colors: [const Color(0xFF0053B9), const Color(0xFF5290EC)],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Start Conversation", style: AppWidget.BottomStyle()),
                  const SizedBox(width: 10),
                  Icon(Icons.arrow_forward,
                      color: Colors.white, size: screenWidth * 0.06),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
