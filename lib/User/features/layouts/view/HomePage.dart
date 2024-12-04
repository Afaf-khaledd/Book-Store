import 'package:book_store/User/features/layouts/view/FavoritePage.dart';
import 'package:book_store/User/features/layouts/view/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../manger/BookCubit/book_cubit.dart';
import 'NotificationPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookCubit>().initializeBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book World'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const FavoritePage(),
                    ),
                    );
                  },
                  icon: const Icon(Icons.favorite,color: mainGreenColor,)
              ),
              IconButton(
                  onPressed: (){
                    // to notification page
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) => const NotificationPage(),
                    ),
                    );
                  },
                  icon: const Icon(Icons.notifications,color: mainGreenColor,)
              ),
              const SizedBox(width: 10,)
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 11),
        child: Column(
          children: [
            InkWell(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  labelText: "Search",
                  enabled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onTap: (){Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) => const SearchPage(),
              ),
              );},
            ),
            //Most popular

            //Best Seller

          ],
        ),
      ),
    );
  }
}