import 'package:book_store/User/features/data/models/BookModel.dart';
import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/CartItemModel.dart';
import '../../data/models/ReviewModel.dart';
import '../manger/AuthCubit/auth_cubit.dart';
import '../manger/CartCubit/cart_cubit.dart';
import '../manger/CategoryUCubit/category_u_cubit.dart';
import '../manger/ReviewCubit/review_cubit.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool _inCart = false;
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    final user = BlocProvider.of<AuthCubit>(context).cachedUser;

    final reviewCubit = BlocProvider.of<ReviewCubit>(context);
    reviewCubit.loadReviews(widget.book.id!);

    if (user != null) {
      BlocProvider.of<CartCubit>(context)
          .isInCart(user.uid, widget.book.id!)
          .then((isInCart) {
        setState(() {
          _inCart = isInCart;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              final user = await BlocProvider.of<AuthCubit>(context).currentUser;
              final previousState = _inCart;
              setState(() {
                _inCart = !_inCart;
              });
              try {
                if (previousState) {
                  await BlocProvider.of<CartCubit>(context).removeFromCart(user!.uid, book.id!);
                } else {
                  final item = CartItemModel(
                    bookId: book.id!,
                    title: book.title!,
                    image: book.thumbnail!,
                    price: book.price!,
                    quantity: 1,
                  );
                  await BlocProvider.of<CartCubit>(context).addToCart(user!.uid, item);
                }
              } catch (e) {
                setState(() {
                  _inCart = previousState;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update cart: $e')),
                );
              }
            },
            icon: Icon(
              _inCart ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  book.thumbnail ?? 'https://via.placeholder.com/150',
                  height: 270,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              book.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${book.authors}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${book.popularity}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber,
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              '${book.price?.toStringAsFixed(2) ?? '0.00'}\$',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CategoryUCubit, CategoryUState>(
                    builder: (context, state) {
                      String categoryName = 'Unknown'; // Default to 'Unknown' if not found

                      if (state is CategoryULoaded) {
                        categoryName = context.read<CategoryUCubit>().getCategoryName(book.category ?? '');
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Genre',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoryName,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Published At',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.publishedDate ?? 'Unknown',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.language ?? 'Unknown',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book.description ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),

            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoading) {
                  return const Center(child: NewLoadingIndicator());
                } else if (state is ReviewLoaded) {
                  final reviews = state.reviews;
                  if (reviews.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.reviews_outlined,
                          size: 100,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Reviews Yet!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Be the first to share your thoughts on this book.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return Column(
                    children: reviews.map((review) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${review.rating}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const Icon(
                                      Icons.star_rate_rounded,
                                      color: Colors.amber,
                                      size: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.review,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else if (state is ReviewError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Write a Review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _reviewController,
                    cursorColor: mainGreenColor,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rate the Book',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final user = BlocProvider.of<AuthCubit>(context).cachedUser;
                        if (user != null && _rating > 0) {
                          final review = ReviewModel(
                            username: user.email,
                            bookId: widget.book.id!,
                            review: _reviewController.text.trim(),
                            rating: _rating,
                          );
                          BlocProvider.of<ReviewCubit>(context).submitReview(review).then((_) {
                            _reviewController.clear();
                            setState(() {
                              _rating = 0;
                            });
                            BlocProvider.of<ReviewCubit>(context).loadReviews(widget.book.id!);
                          });
                        }
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text('Submit', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainGreenColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
