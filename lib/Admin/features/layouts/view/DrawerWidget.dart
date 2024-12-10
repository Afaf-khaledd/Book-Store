import 'package:book_store/Admin/features/layouts/view/BooksPage.dart';
import 'package:book_store/Admin/features/layouts/view/CategoryPage.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../User/features/layouts/manger/AuthCubit/auth_cubit.dart';
import '../../../../User/features/layouts/view/OnboardingPage.dart';
import '../../../../Admin/features/layouts/view/OrderPage.dart';
import 'Dashboard.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: mainGreenColor,
            ),
            child: Align(alignment: Alignment.centerLeft,child: Text('Welcome Admin,'),),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.bar_chart_rounded),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const DashboardPage(),
                  ),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_rounded),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            title: const Text('Orders'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const OrderPage(),
                  ),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.border_all_rounded),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            title: const Text('Categories'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CategoryPage(),
                  ),
                );
              },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            title: const Text('Books'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const BooksPage(),
                  ),
                );
              },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            title: const Text('Logout'),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
    );
  }
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<AuthCubit>(context).logout();
              Navigator.pushReplacement(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => const OnboardingPage(),
              ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainGreenColor,
            ),
            child: const Text('Logout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    );
  }
}
