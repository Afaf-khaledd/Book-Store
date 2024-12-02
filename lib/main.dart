import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'User/features/layouts/view/SplashScreen.dart';
import 'constant.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(//.router
      //routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: appBGColor,
      ),
      home: const SplashPage(),
    );
  }
}
