class OnboardingContent {
  String images;
  String title;
  String description;
  OnboardingContent(
      {required this.images, required this.title, required this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
      images: 'images/onboard1.png',
      title: "Don't Worry",
      description:
          'Empowering your mental well-being\n   with innovative AI-driven therapy'),
  OnboardingContent(
      images: 'images/onboard2.png',
      title: 'Keep Calm ',
      description:
          '       A safe space for your emotions ,\n   guided by compassionate technology'),
  OnboardingContent(
      images: 'images/onboard3.png',
      title: ' Be Relax ',
      description:
          '              Transform your mind ,\n   one session at a time with Therapy ')
];
