import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/BookModel.dart';
import '../../data/repoistry/FavoritesRepository.dart';
import '../manger/BookCubit/book_cubit.dart';
import 'BookCard.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritePage> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }
  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
