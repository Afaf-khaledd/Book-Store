import 'package:book_store/User/features/data/repoistry/OrderRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../../data/models/UserModel.dart';
import '../manger/AuthCubit/auth_cubit.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late UserModel user;
  final OrderRepository orderService = OrderRepository();


  @override
  void initState() {
    super.initState();
    final authCubit = BlocProvider.of<AuthCubit>(context);
    user = authCubit.cachedUser!;
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyOrderUI(context);
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'] as List<dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${index+1}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      Text("Date: ${order['date'].toDate()}",style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      Row(
                        children: [
                          const Text(
                            "Status: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${order['status']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(order['status']),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("Total Cost: \$${order['totalCost'].toStringAsFixed(2)}",style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      const Divider(),
                      const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                      ...items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "- ${item['bookTitle']} | Qty: ${item['quantity']} | \$${item['totalCost'].toStringAsFixed(2)}",
                        ),
                      )),
                      const SizedBox(height: 8),
                      if (order['status'] == 'pending')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainGreenColor,
                          ),
                          onPressed: () {
                            _showCancelConfirmation(context, order);
                          },
                          child: const Text("Cancel Order",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  void _showCancelConfirmation(BuildContext context,QueryDocumentSnapshot<Object?> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              orderService.cancelOrder(order['orderId']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainGreenColor,
            ),
            child: const Text('Cancel Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyOrderUI(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Your order history is empty!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Browse the home page and buy some books.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}