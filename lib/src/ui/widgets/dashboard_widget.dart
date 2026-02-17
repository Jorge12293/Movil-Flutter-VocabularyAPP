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
  String totalStudyTime = '0 min';
  double averageScore = 0.0;
  List<TestResult> todayResults = [];
  Map<String, int> last30DaysStats = {};
  Map<String, String> pageBreakdown = {};
  Map<String, double> topicScores = {};
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
    
    final time = await manager.getTotalStudyTimeFormatted();
    final avg = await manager.getAverageScore();
    final today = await manager.getTodayResults();
    final last30 = await manager.getLast30DaysDailyStudyTime();
    final pages = await manager.getPageStudyBreakdown();
    final topics = await manager.getTopicScoreBreakdown();

    if (mounted) {
      setState(() {
        totalStudyTime = time;
        averageScore = avg;
        todayResults = today;
        last30DaysStats = last30;
        pageBreakdown = pages;
        topicScores = topics;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const SizedBox.shrink();

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
                      'Total Tiempo',
                      totalStudyTime,
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
                      'Promedio General',
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
        
        // Grafica Reciente (Solo Hoy)
        _buildSectionTitle(context, 'Progreso de Hoy'),
        const SizedBox(height: 10),
        _buildTodayChart(context, isDark),
        
        const SizedBox(height: 20),

        // Grafica 30 Dias
        _buildSectionTitle(context, 'Tiempo de Estudio (30 Días)'),
        const SizedBox(height: 10),
        _buildLast30DaysChart(context, isDark),

        const SizedBox(height: 20),

        // Desglose por Pagina
        _buildSectionTitle(context, 'Tiempo por Página'),
        const SizedBox(height: 10),
        _buildPageBreakdownParams(context, isDark),

        const SizedBox(height: 20),

        // Promedio por Tema
        _buildSectionTitle(context, 'Promedio por Tema'),
        const SizedBox(height: 10),
        _buildTopicScoreBreakdown(context, isDark),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildTodayChart(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(20),
        height: 250,
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
        child: todayResults.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.today, size: 50, color: Colors.grey.withOpacity(0.5)),
                    const SizedBox(height: 10),
                    Text(
                      "Sin actividad hoy",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getTodaySpots(),
                      isCurved: true,
                      color: theme.primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
      ),
    );
  }

  List<FlSpot> _getTodaySpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < todayResults.length; i++) {
      double percentage = (todayResults[i].score / todayResults[i].total) * 100;
      spots.add(FlSpot(i.toDouble(), percentage));
    }
    return spots;
  }

  Widget _buildLast30DaysChart(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final keys = last30DaysStats.keys.toList();
    // Sort keys just in case, though stats manager returns ordered
    keys.sort(); 
    
    // Convert to spots for BarChart
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < keys.length; i++) {
      // Show only every 5th day or so to avoid clutter? 
      // Or just show last 7 days? User asked for 30 days.
      // 30 bars fit on a screen if thin.
      double minutes = (last30DaysStats[keys[i]] ?? 0) / 60;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: minutes,
              color: theme.primaryColor,
              width: 6,
              borderRadius: BorderRadius.circular(2),
            )
          ],
        ),
      );
    }

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(20),
        height: 250,
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
        child: BarChart(
          BarChartData(
            barGroups: barGroups,
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < keys.length) {
                      // Show date every 5 days
                      if (index % 5 == 0) {
                        final dateParts = keys[index].split('-');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${dateParts[2]}/${dateParts[1]}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _buildPageBreakdownParams(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(20),
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
          children: pageBreakdown.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopicScoreBreakdown(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.all(20),
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
          children: topicScores.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                      entry.key,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  Text(
                    '${entry.value.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(entry.value),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
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
