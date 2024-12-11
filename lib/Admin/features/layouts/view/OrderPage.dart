import 'package:book_store/Admin/features/layouts/manger/OrdersCubit/orders_cubit.dart';
import 'package:book_store/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'DrawerWidget.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  cubit.fetchOrdersForReport(selectedDate);
                }
              },
              icon: const Icon(Icons.date_range),
              label: const Text('Select Date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainGreenColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrdersReportLoaded) {
                    if (state.reportOrders.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_rounded,
                                size: 150,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No orders found for this date.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.reportOrders.length,
                      itemBuilder: (context, index) {
                        final order = state.reportOrders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Order ID: ${order.orderId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User ID: ${order.userId}'),
                                Text('Date: ${order.date.toLocal()}'),
                                Text('Total: \$${order.totalCost}'),
                                Text('Status: ${order.status}'),
                              ],
                            ),
                            trailing: DropdownButton<String>(
                              value: order.status,
                              items: const [
                                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                                DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
                                DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                                DropdownMenuItem(
                                  value: 'cancelled',
                                  enabled: false,
                                  child: Text(
                                    'Cancelled',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null && value != 'cancelled') {
                                  context.read<OrdersCubit>().updateOrderStatus(order.orderId, value);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is OrdersError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}