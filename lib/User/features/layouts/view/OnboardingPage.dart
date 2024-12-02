import 'package:book_store/User/features/layouts/view/LoginPage.dart';
import 'package:book_store/User/features/layouts/view/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constant.dart';
import 'OnboardingPageBody.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: const [
                  OnboardingPageBody(
                    title: "Welcome To World Book",
                    description: "Discover a world of stories and knowledge at your fingertips. You can browse an extensive library of books spanning genres. Our application ensures an enjoyable browsing experience tailored just for you.",
                    url: 'images/gs11.png',
                  ),
                  OnboardingPageBody(
                    title: "AnyTime, AnyWhere",
                    description: "Personalize your experience save your favorite books, track your orders, and manage your account with ease. With just a few clicks, your next great read will be on its way to your doorstep.",
                    url: 'images/gs2.jpg',
                  ),
                  OnboardingPageBody(
                    title: "Stay Connected",
                    description: "Track your order and leave reviews for books you've enjoyed. Your feedback not only helps others but also builds a community of book enthusiasts who share your passion.",
                    url: 'images/gs3.jpg',
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: mainGreenColor,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreenColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const SignUp(),
                  ),
                  );                },
                child: const Text(
                  "Create New Account",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: appBGColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBGColor,
                  side: const BorderSide(
                    color: mainGreenColor,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                  );
                  // nav
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: mainGreenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35,),
          ],
        ),
      ),
    );
  }
}
