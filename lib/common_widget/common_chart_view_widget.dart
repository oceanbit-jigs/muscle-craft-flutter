import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CommonLineChartView extends StatelessWidget {
  final String xAxisLabel;
  final String yAxisLabel;
  final List<double> values;
  final bool showKg;
  final List<FlSpot> Function(List<double>) generatePoints;
  final String? chartType;

  const CommonLineChartView({
    super.key,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.values,
    required this.showKg,
    required this.generatePoints,
    this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    // final maxValue = values.reduce((a, b) => a > b ? a : b);
    // final minValue = values.reduce((a, b) => a < b ? a : b);

    final maxValue = values.isNotEmpty
        ? values.reduce((a, b) => a > b ? a : b)
        : 0.0;
    final minValue = values.isNotEmpty
        ? values.reduce((a, b) => a < b ? a : b)
        : 0.0;

    final topMargin = maxValue * 0.15;
    final bottomMargin = minValue * 0.1;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFF404040),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final days = values.length;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    // width: days * 30,
                    width: (days * 30).toDouble() < constraints.maxWidth
                        ? constraints.maxWidth
                        : (days * 30).toDouble(),
                    height: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 37,
                        right: 10,
                        top: 30,
                      ),
                      child: LineChart(
                        LineChartData(
                          minX: 1,
                          maxX: days.toDouble(),
                          minY: minValue - bottomMargin,
                          maxY: maxValue + topMargin,
                          clipData: FlClipData.none(),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (spots) => spots
                                  .map(
                                    (spot) => LineTooltipItem(
                                      spot.y.toStringAsFixed(1),
                                      const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 28,
                                // getTitlesWidget: (value, meta) =>
                                //     SideTitleWidget(
                                //       axisSide: meta.axisSide,
                                //       space: 8,
                                //       child: Text(
                                //         value.toInt().toString(),
                                //         style: const TextStyle(
                                //           color: Colors.white70,
                                //           fontSize: 10,
                                //         ),
                                //       ),
                                //     ),
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();

                                  String text = "";

                                  // if (chartType == "Daily") {
                                  //   text = index.toString(); // 1,2,3...
                                  // }
                                  if (chartType == "Daily") {
                                    if (values.length == 7) {
                                      const days = [
                                        'M',
                                        'T',
                                        'W',
                                        'T',
                                        'F',
                                        'S',
                                        'S',
                                      ];

                                      if (index >= 1 && index <= 7) {
                                        text = days[index - 1];
                                      } else {
                                        text = "";
                                      }
                                    } else {
                                      text = index.toString(); // 1,2,3...
                                    }
                                  } else if (chartType == "Weekly") {
                                    text = "W$index"; // Week 1, Week 2...
                                  } else if (chartType == "Monthly") {
                                    const months = [
                                      "Jan",
                                      "Feb",
                                      "Mar",
                                      "Apr",
                                      "May",
                                      "Jun",
                                      "Jul",
                                      "Aug",
                                      "Sep",
                                      "Oct",
                                      "Nov",
                                      "Dec",
                                    ];

                                    if (index <= months.length) {
                                      text = months[index - 1];
                                    } else {
                                      text = "";
                                    }
                                  }

                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 8,
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: generatePoints(values),
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.orangeAccent,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // X-AXIS LABEL
        Positioned(
          bottom: 0,
          child: Text(
            xAxisLabel,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Y AXIS LABEL (VERTICAL)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                yAxisLabel,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // STATIC Y-AXIS TICKS
        Positioned(
          left: 5,
          top: 20,
          bottom: 15,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (i) {
                double maxY = maxValue + 2;
                double step = maxY / 4;
                double value = step * (4 - i);

                double displayValue = showKg ? value : value * 2.20462;

                return Text(
                  displayValue.toInt().toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
