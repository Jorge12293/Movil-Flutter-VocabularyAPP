import 'package:shared_preferences/shared_preferences.dart';
import 'package:appbasicvocabulary/src/helpers/utils/enums.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class TestResult {
  final int score;
  final int total;
  final EvaluationType type;
  final DateTime date;

  TestResult({
    required this.score,
    required this.total,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'score': score,
        'total': total,
        'type': type.toString(),
        'date': date.toIso8601String(),
      };

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      score: json['score'],
      total: json['total'],
      type: EvaluationType.values.firstWhere((e) => e.toString() == json['type']),
      date: DateTime.parse(json['date']),
    );
  }
}

class StatisticsManager with ChangeNotifier {
  static final StatisticsManager _instance = StatisticsManager._internal();
  factory StatisticsManager() => _instance;
  StatisticsManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> resetAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
    notifyListeners();
  }

  // --- Study Time Tracking ---

  Future<void> saveStudySession(String page, int seconds) async {
    if (_prefs == null) await init();

    // 1. Total Global Time
    int currentTotal = _prefs!.getInt('total_study_time') ?? 0;
    await _prefs!.setInt('total_study_time', currentTotal + seconds);

    // 2. Daily Time (for graphs)
    final today = DateTime.now();
    final dayKey = 'study_daily_${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    int currentDaily = _prefs!.getInt(dayKey) ?? 0;
    await _prefs!.setInt(dayKey, currentDaily + seconds);

    // 3. Page Breakdown
    Map<String, dynamic> pageStats = {};
    String? pageStatsJson = _prefs!.getString('study_page_stats');
    if (pageStatsJson != null) {
      pageStats = jsonDecode(pageStatsJson);
    }
    int currentPageTime = pageStats[page] ?? 0;
    pageStats[page] = currentPageTime + seconds;
    await _prefs!.setString('study_page_stats', jsonEncode(pageStats));

    notifyListeners();
  }

  Future<String> getTotalStudyTimeFormatted() async {
    if (_prefs == null) await init();
    int totalSeconds = _prefs!.getInt('total_study_time') ?? 0;
    return _formatDuration(totalSeconds);
  }

  Future<Map<String, int>> getLast30DaysDailyStudyTime() async {
    if (_prefs == null) await init();
    Map<String, int> stats = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final key = 'study_daily_${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
      int seconds = _prefs!.getInt(key) ?? 0;
      // Store key as simple date string or index for chart
      stats[date.toIso8601String().split('T')[0]] = seconds;
    }
    return stats;
  }
  
  Future<int> getTodayStudyTime() async {
    if (_prefs == null) await init();
    final today = DateTime.now();
    final key = 'study_daily_${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    return _prefs!.getInt(key) ?? 0;
  }

  Future<Map<String, String>> getPageStudyBreakdown() async {
    if (_prefs == null) await init();
    String? pageStatsJson = _prefs!.getString('study_page_stats');
    if (pageStatsJson == null) return {};

    Map<String, dynamic> rawStats = jsonDecode(pageStatsJson);
    Map<String, String> formattedStats = {};

    rawStats.forEach((key, value) {
      formattedStats[key] = _formatDuration(value as int);
    });
    return formattedStats;
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '$seconds seg';
    if (seconds < 3600) return '${(seconds / 60).toStringAsFixed(1)} min';
    return '${(seconds / 3600).toStringAsFixed(1)} hrs';
  }

  // --- Test Results & Scores ---

  Future<void> saveTestResult(int score, int total, EvaluationType type) async {
    if (_prefs == null) await init();
    
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    
    final newResult = TestResult(
      score: score,
      total: total,
      type: type,
      date: DateTime.now(),
    );
    
    results.add(jsonEncode(newResult.toJson()));
    
    // Increased limit to 100 to allow for better averaging over time
    if (results.length > 100) {
      results = results.sublist(results.length - 100);
    }
    
    await _prefs!.setStringList('test_results', results);
    notifyListeners();
  }

  Future<List<TestResult>> getRecentResults() async {
    if (_prefs == null) await init();
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    return results.map((e) => TestResult.fromJson(jsonDecode(e))).toList();
  }
  
  Future<List<TestResult>> getTodayResults() async {
    if (_prefs == null) await init();
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    
    return results
        .map((e) => TestResult.fromJson(jsonDecode(e)))
        .where((r) => r.date.isAfter(todayStart))
        .toList();
  }

  Future<double> getAverageScore() async {
    if (_prefs == null) await init();
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    if (results.isEmpty) return 0.0;
    
    double totalPercentage = 0;
    for (String r in results) {
      final res = TestResult.fromJson(jsonDecode(r));
      totalPercentage += (res.score / res.total);
    }
    
    return (totalPercentage / results.length) * 100;
  }
  
  Future<Map<String, double>> getTopicScoreBreakdown() async {
     if (_prefs == null) await init();
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    if (results.isEmpty) return {};
    
    Map<String, List<double>> topicScores = {};
    
    for (String r in results) {
      final res = TestResult.fromJson(jsonDecode(r));
      final typeStr = res.type.toString().split('.').last.toUpperCase();
      
      if (!topicScores.containsKey(typeStr)) {
        topicScores[typeStr] = [];
      }
      topicScores[typeStr]!.add(res.score / res.total);
    }
    
    Map<String, double> averages = {};
    topicScores.forEach((key, value) {
      double total = value.reduce((a, b) => a + b);
      averages[key] = (total / value.length) * 100;
    });
    
    return averages;
  }

  // --- Backward Compatibility ---
  
  @Deprecated('Use saveStudySession instead')
  Future<void> saveStudyTime(int seconds) async {
    await saveStudySession('General', seconds);
  }

  // Restored for DashBoardWidget compatibility until refactor
  Future<String> getFormattedStudyTime() async {
    return getTotalStudyTimeFormatted();
  }
}
