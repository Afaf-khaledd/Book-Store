import 'package:flutter/material.dart';

class OnboardingPageBody extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const OnboardingPageBody({
    super.key,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Image.asset(url, width: double.infinity),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}