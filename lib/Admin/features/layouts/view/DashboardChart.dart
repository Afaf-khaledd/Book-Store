import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  final String title;
  final List<ChartData> data;

  const DashboardChart({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final chartData = data.map((e) {
      return BarChartGroupData(
        x: data.indexOf(e), // Using index as x-axis position
        barRods: [
          BarChartRodData(
            toY: e.value.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Return category name based on x-axis position (value)
                          return Text(data[value.toInt()].label,
                              style: const TextStyle(fontSize: 8));
                        },
                        //margin: 8,
                        //rotateAngle: 45, // Rotate labels to avoid overlap
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: chartData,
                  gridData: const FlGridData(show: true),
                  alignment: BarChartAlignment.spaceBetween,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label; // Name of the category (for x-axis)
  final int value;

  ChartData(this.label, this.value);
}