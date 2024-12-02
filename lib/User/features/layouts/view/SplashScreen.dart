import 'package:book_store/User/features/layouts/view/OnboardingPage.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/splash1.png',width: 270,),
                const Text("BOOK WORLD",style: TextStyle(color: Color(0xff4a5447),fontSize: 33,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff4a5447).withOpacity(0.1),
                  const Color(0xff4a5447).withOpacity(0.6),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }
  void navigateToHome() {
    Future.delayed(const Duration(seconds: 3),(){
      // nav
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) => const OnboardingPage(),
      ),
      );
    });
  }

}
