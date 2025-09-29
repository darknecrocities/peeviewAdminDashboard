import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RecentChartCard extends StatelessWidget {
  const RecentChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Patients',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              '235 New Patients this month',
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (v) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 4,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: const [
                        FlSpot(0, 0.8),
                        FlSpot(1, 1.2),
                        FlSpot(2, 0.9),
                        FlSpot(3, 2.2),
                        FlSpot(4, 1.8),
                        FlSpot(5, 3.1),
                      ],
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 4, // replaces old dotSize
                              color: Colors.blue,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            ),
                      ),
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.25),
                            Colors.blue.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
