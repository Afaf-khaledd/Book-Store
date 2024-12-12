import 'package:book_store/User/features/data/repoistry/OrderRepo.dart';
import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/OrderModel.dart';
import '../manger/AuthCubit/auth_cubit.dart';
import '../manger/CartCubit/cart_cubit.dart';
import 'CartItem.dart';
import 'OrderPage.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderRepository orderService = OrderRepository();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: NewLoadingIndicator());
          } else if (state is CartLoaded) {
            final cartItems = state.items;
            double totalPrice = 0.0;
            for (var item in cartItems) {
              totalPrice += item.price * item.quantity;
            }
            if (cartItems.isEmpty) {
              return _buildEmptyCartUI(context);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 4),
                    child: Text(
                      'You have ${cartItems.length} items in cart',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mainGreenColor
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return CartItem(item: item);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Price',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Charge',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$50.00',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment Way',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Cash on delivery',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Colors.grey,
                                height: 20,
                                thickness: 0.4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'You Pay',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${(totalPrice + 50).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainGreenColor,
                                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  final cartCubit = context.read<CartCubit>();
                                  final authCubit = BlocProvider.of<AuthCubit>(context).cachedUser!;
                                  final cartItems = cartCubit.state is CartLoaded
                                      ? (cartCubit.state as CartLoaded).items
                                      : [];
                                  final totalPrice = cartItems.fold<double>(
                                      0.0, (sum, item) => sum + (item.price * item.quantity));
                                  final cartData = cartItems.map((item) {
                                    return OrderItem(
                                      bookId: item.bookId,
                                      bookTitle: item.title,
                                      quantity: item.quantity,
                                      costPerItem: item.price,
                                      totalCost: item.price * item.quantity,
                                    );
                                  }).toList();
                                  await orderService.placeOrder(authCubit.uid, cartData, totalPrice + 50);

                                  cartCubit.clearCartState();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) => const OrderPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("Bad Network!"));
        },
      ),
    );
  }

  Widget _buildEmptyCartUI(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Your cart is empty!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Browse the home page and add books to your cart.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}