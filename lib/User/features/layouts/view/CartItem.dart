import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../../data/models/CartItemModel.dart';
import '../../data/models/UserModel.dart';
import '../manger/AuthCubit/auth_cubit.dart';
import '../manger/CartCubit/cart_cubit.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.item});
  final CartItemModel item;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    final authCubit = BlocProvider.of<AuthCubit>(context);
    user = authCubit.cachedUser!;
  }

  @override
  Widget build(BuildContext context) {
    int totalItemPrice = widget.item.price * widget.item.quantity;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Image.network(
          widget.item.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(widget.item.title),
        subtitle: Text('Total Price: \$${totalItemPrice.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                if (widget.item.quantity > 1) {
                  BlocProvider.of<CartCubit>(context).updateQuantity(user.uid,widget.item.bookId, -1);
                }
              },
            ),
            Text('${widget.item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                BlocProvider.of<CartCubit>(context).updateQuantity(user.uid,widget.item.bookId, 1);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from cart'),
        content: const Text('Are you sure you want to remove this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<CartCubit>(context).removeFromCart(user.uid, widget.item.bookId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainGreenColor,
            ),
            child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    );
  }
}
