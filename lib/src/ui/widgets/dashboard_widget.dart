import 'package:appbasicvocabulary/src/helpers/utils/statistics_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  String studyTime = '0 min';
  double averageScore = 0.0;
  List<TestResult> recentResults = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
    StatisticsManager().addListener(loadStats);
  }

  @override
  void dispose() {
    StatisticsManager().removeListener(loadStats);
    super.dispose();
  }

  Future<void> loadStats() async {
    final manager = StatisticsManager();
    await manager.init();
    
    final time = await manager.getFormattedStudyTime();
    final avg = await manager.getAverageScore();
    final results = await manager.getRecentResults();

    if (mounted) {
      setState(() {
        studyTime = time;
        averageScore = avg;
        recentResults = results;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const SizedBox.shrink(); // Or generic loading

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FadeInLeft(
                    child: _buildStatCard(
                      context,
                      'Tiempo de Estudio',
                      studyTime,
                      Icons.timer,
                      Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: FadeInRight(
                    child: _buildStatCard(
                      context,
                      'Promedio',
                      '${averageScore.toStringAsFixed(1)}%',
                      Icons.analytics,
                      Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(20),
            height: 300,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso Reciente',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: recentResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bar_chart_rounded, size: 50, color: Colors.grey.withOpacity(0.5)),
                              const SizedBox(height: 10),
                              Text(
                                "Completa una evaluación para ver tu progreso",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 20,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: theme.dividerColor.withOpacity(0.1),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) => theme.cardColor,
                                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                                  return touchedBarSpots.map((barSpot) {
                                    return LineTooltipItem(
                                      '${barSpot.y.toInt()}%',
                                      GoogleFonts.poppins(
                                        color: theme.textTheme.bodyLarge?.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _getSpots(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.5)],
                                ),
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: theme.cardColor,
                                      strokeWidth: 2,
                                      strokeColor: theme.primaryColor,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.primaryColor.withOpacity(0.3),
                                      theme.primaryColor.withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                            minY: 0,
                            maxY: 100,
                          ),
                          duration: const Duration(milliseconds: 1000), // Animation duration
                          curve: Curves.easeInOut, // Animation curve
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    if (recentResults.isEmpty) return [];
    List<FlSpot> spots = [];
    for (int i = 0; i < recentResults.length; i++) {
      double percentage = (recentResults[i].score / recentResults[i].total) * 100;
      spots.add(FlSpot(i.toDouble(), percentage));
    }
    return spots;
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
