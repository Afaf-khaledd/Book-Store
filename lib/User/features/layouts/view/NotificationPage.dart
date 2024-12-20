import 'package:book_store/User/features/layouts/view/LoadingIndicator.dart';
import 'package:book_store/User/features/layouts/view/OrderHistoryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant.dart';
import '../../data/repoistry/NotificationRepo.dart';
import '../manger/NotificationCubit/notification_cubit.dart';

class NotificationPage extends StatelessWidget {
  final String userId;

  const NotificationPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        title: const Text('Notifications',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: mainGreenColor),),
      ),
      body: BlocProvider(
        create: (context) => NotificationCubit(NotificationRepository())..fetchNotifications(userId),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: NewLoadingIndicator());
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications_off, size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        'Waiting for your order to be shipped or confirmed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text('Order ID: ${notification.orderId}'),
                      subtitle: Text('Status: ${notification.status}'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) => const OrderHistoryPage(),
                        ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is NotificationError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('Unexpected state.'),
              );
            }
          },
        ),
      ),
    );
  }
}