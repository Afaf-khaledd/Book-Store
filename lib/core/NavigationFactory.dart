import 'package:flutter/material.dart';

import '../Admin/features/layouts/view/Dashboard.dart';
import '../User/features/layouts/view/MainNavPage.dart';
import '../User/features/layouts/view/OnboardingPage.dart';

class NavigationFactory {
  static Widget getNextPage({required bool rememberMe, bool? isAdmin, String? email, String? password}) {
    if (rememberMe) {
      if (isAdmin == true) {
        return const DashboardPage();
      } else {
        return const MainNavPage();
      }
    }
    if (email == "admin@store.com" && password == "admin1") {
      return const DashboardPage();
    }
    else if(email != null && password != null){
      return const MainNavPage();
    }
    return const OnboardingPage();
  }
}