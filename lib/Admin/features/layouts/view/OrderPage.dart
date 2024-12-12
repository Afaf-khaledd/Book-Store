import 'package:book_store/Admin/features/layouts/manger/OrdersCubit/orders_cubit.dart';
import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
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
        title: const Text('Manage Orders',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: mainGreenColor),),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
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
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: mainGreenColor,
                          colorScheme: const ColorScheme.light(
                            primary: mainGreenColor,
                            onPrimary: Colors.white,
                          ),
                          buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: mainGreenColor,
                            ),
                          ),
                          // Customizing text styles
                          textTheme: const TextTheme(
                            bodyMedium: TextStyle(color: Colors.black),
                            labelMedium: TextStyle(color: mainGreenColor),
                          ),
                        ),
                        child: child ?? const SizedBox.shrink(),
                      );
                    },
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
                      return const Center(child: NewLoadingIndicator());
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
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0), // Rounded corners for a smooth design
                            ),
                            elevation: 4.0, // Adding elevation for shadow effect
                            child: Padding(
                              padding: const EdgeInsets.all(16.0), // Padding inside the card
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title of the Order
                                  Text(
                                    'Order #${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0), // Adding space between title and content
                                  // Date, Total, and Status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Date: ${order.date.toLocal()}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Total: \$${order.totalCost.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Status Dropdown Button
                                      DropdownButton<String>(
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
                                            context.read<OrdersCubit>().updateOrderStatus(order.orderId, value, order.userId);
                                          }
                                        },
                                        style: const TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: mainGreenColor
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                  // Display Order Items
                                  const Text(
                                    'Order Items:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: order.items.map<Widget>((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          '- ${item.bookTitle} x${item.quantity} - \$${(item.costPerItem * item.quantity).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
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
      ),
      drawer: const DrawerWidget(),
    );
  }
}