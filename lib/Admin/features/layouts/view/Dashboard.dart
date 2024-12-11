import 'package:book_store/Admin/features/layouts/view/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manger/DashboardCubit/dashboard_cubit.dart';
import 'DashboardCard.dart';
import 'DashboardChart.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    final dashboardCubit = context.read<DashboardCubit>();

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DashboardCard(
                          title: 'Total Users',
                          value: state.totalUsers.toString(),
                          icon: Icons.person,
                          color: Colors.green,
                        ),
                        DashboardCard(
                          title: 'Total Orders',
                          value: state.totalOrders.toString(),
                          icon: Icons.shopping_cart,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DashboardCard(
                          title: 'Total Books',
                          value: state.totalBooks.toString(),
                          icon: Icons.book,
                          color: Colors.orange,
                        ),
                        DashboardCard(
                          title: 'Total Categories',
                          value: state.totalCategories.toString(),
                          icon: Icons.category,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DashboardChart(
                      title: 'Popular Categories',
                      data: state.popularCategories.map((e) {
                        return ChartData(e['name'], e['count']);
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DashboardChart(
                      title: 'Best-Selling Books',
                      data: state.bestSellingBooks.map((e) {
                        return ChartData(e['title'], e['sales']);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}