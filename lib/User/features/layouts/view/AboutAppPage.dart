import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About The App'),
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the Book Store App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '''A one-stop destination for book lovers. Whether you're looking for the latest bestsellers, classic literature, or niche genres, we’ve got it all. Our mission is to provide a seamless shopping experience that caters to all your reading needs.
               
With our easy-to-navigate platform, you can explore a wide variety of books, search for your favorite titles, and discover new authors. Our app allows you to browse books by category, author, or popularity. You can also manage your wishlist, keep track of your order history, and leave reviews for the books you purchase.
               
We believe that books have the power to change lives, and we are committed to sharing that power with our users. Whether you're an avid reader, a casual book buyer, or someone just starting their reading journey, our app is designed to help you find the perfect book every time.
              
      Thank you for choosing the Book Store App, where your next adventure is just a book away!
              
                Happy reading!''',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}