import 'package:book_store/Admin/features/layouts/view/DrawerWidget.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        title: const Text("Availability"),
      ),
      body: const Center(),
      drawer: const DrawerWidget(),
    );
  }
}
