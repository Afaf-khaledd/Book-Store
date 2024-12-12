import 'package:book_store/constant.dart';
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
        x: data.indexOf(e),
        barRods: [
          BarChartRodData(
            toY: e.value.toDouble(),
            color: mainGreenColor,
            width: 18,
            borderRadius: BorderRadius.circular(8), // Smooth bar edges
          ),
        ],
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
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
              height: 250,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          final label = data[value.toInt()].label;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: 1, // Rotate labels vertically
                              child: SizedBox(
                                width: 40, // Set a fixed width to control wrapping
                                child: Text(
                                  label,
                                  maxLines: 2, // Limit to 2 lines
                                  overflow: TextOverflow.ellipsis, // Add ellipsis for truncation
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      //tooltipBgColor: Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          "${data[group.x.toInt()].label}\n${rod.toY.toInt()}",
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  barGroups: chartData,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 10,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  alignment: BarChartAlignment.spaceAround,
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