import 'package:flutter/material.dart';
import 'package:therapy/constants/colors.dart';
import 'package:therapy/constants/textstyle.dart';
import 'package:therapy/screen/auth/pages/login.dart';
import 'package:therapy/screen/onboarding/model/content_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Skip", style: AppWidget.SkipStyle()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return ListView(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              contents[i].images,
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              contents[i].title,
                              style: AppWidget.Headline(),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              contents[i].description,
                              style: AppWidget.OnboardStyle(),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 51,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              contents.length,
                              (index) => buildDot(index, context),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (currentIndex == contents.length - 1) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            }
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.bounceIn);
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColor.blue,
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                currentIndex == contents.length - 3
                                    ? "Start"
                                    : currentIndex == contents.length - 2
                                        ? "Next"
                                        : "Get Started",
                                style: AppWidget.BottomStyle(),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 12,
      width: currentIndex == index ? 20 : 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: currentIndex == index ? AppColor.blue : AppColor.lightGrey),
    );
  }
}
