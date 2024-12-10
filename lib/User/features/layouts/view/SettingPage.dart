import 'package:book_store/User/features/layouts/view/AboutAppPage.dart';
import 'package:book_store/User/features/layouts/view/CartPage.dart';
import 'package:book_store/User/features/layouts/view/EditProfilePage.dart';
import 'package:book_store/User/features/layouts/view/OnboardingPage.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manger/AuthCubit/auth_cubit.dart';
import 'OrderHistoryPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
        title: 'Edit Profile',
        icon: Icons.person,
        onTap: () async {
          final user = await BlocProvider.of<AuthCubit>(context).currentUser;
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
            );
          } else {
            print('No user logged in');
          }
        },
      ),
      _MenuItem(
        title: 'My Orders',
        icon: Icons.shopping_bag,
        onTap: () async{
          final user = await BlocProvider.of<AuthCubit>(context).currentUser;
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
            );
          } else {
            print('No user logged in');
          }
        },
      ),
      _MenuItem(
        title: 'About App',
        icon: Icons.info,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutAppPage()),
          );
        },
      ),
      _MenuItem(
        title: 'Logout',
        icon: Icons.logout,
        onTap: () {
          _showLogoutConfirmation(context);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
        toolbarHeight: 80,
      ),
      body: ListView.separated(
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1.5,thickness: 0.1,indent: 11,endIndent: 11,color: mainGreenColor,),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item.icon, color: mainGreenColor),
            title: Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: item.onTap,
          );
        },
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

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}