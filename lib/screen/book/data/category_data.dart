import 'package:flutter/material.dart';
import 'package:therapy/screen/book/widgets/category_card.dart';

class CategoriesList extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      "title": "Depression",
      "description": "Types include Major Depression, SAD, and Postpartum.",
      "image": "images/depression.png"
    },
    {
      "title": "Anxiety",
      "description": "Covers GAD, Phobias, and Social Anxiety.",
      "image": "images/Anxiety.png"
    },
    {
      "title": "Stress",
      "description": "Reaction to pressure affecting health.",
      "image": "images/Stress.png"
    },
    {
      "title": "Bipolar Disorder",
      "description": "Mood swings between mania and depression.",
      "image": "images/bipoler.png"
    },
    {
      "title": "Schizophrenia",
      "description": "Includes schizophrenia and schizoaffective disorder.",
      "image": "images/shezo.png"
    },
    {
      "title": "OCD",
      "description": "Obsessive thoughts and compulsive behaviors.",
      "image": "images/ocd.png"
    },
    {
      "title": "Personality Disorders",
      "description": "Includes BPD, Narcissism, and Antisocial Disorder.",
      "image": "images/social (1).png"
    },
    {
      "title": "Eating Disorders",
      "description": "Covers Anorexia and Bulimia.",
      "image": "images/eat.png"
    },
    {
      "title": "Sleep Disorders",
      "description": "Issues like insomnia and sleep apnea.",
      "image": "images/sleep.png"
    },
    {
      "title": "ADHD",
      "description": "Includes ADHD and Autism.",
      "image": "images/adhd.png"
    },
    {
      "title": "Social Anxiety Disorder",
      "description": "Fear of social interactions.",
      "image": "images/social.png"
    },
    {
      "title": "Psychosomatic Disorders",
      "description": "Mental disorders affecting the body.",
      "image": "images/social (2).png"
    },
    {
      "title": "Coping with Trauma",
      "description": "Techniques for emotional recovery.",
      "image": "images/truma.png"
    }
  ];

  CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          title: categories[index]["title"]!,
          description: categories[index]["description"]!,
          image: categories[index]["image"]!,
        );
      },
    );
  }
}
