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
    await _prefs!.remove('total_study_time');
    await _prefs!.remove('test_results');
    notifyListeners();
  }

  Future<void> saveStudyTime(int seconds) async {
    if (_prefs == null) await init();
    int current = _prefs!.getInt('total_study_time') ?? 0;
    await _prefs!.setInt('total_study_time', current + seconds);
    notifyListeners();
  }

  Future<String> getFormattedStudyTime() async {
    if (_prefs == null) await init();
    int totalSeconds = _prefs!.getInt('total_study_time') ?? 0;
    
    if (totalSeconds < 60) return '$totalSeconds seg';
    if (totalSeconds < 3600) return '${(totalSeconds / 60).toStringAsFixed(1)} min';
    return '${(totalSeconds / 3600).toStringAsFixed(1)} hrs';
  }

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
    
    // Keep only last 20 results to avoid huge storage
    if (results.length > 20) {
      results = results.sublist(results.length - 20);
    }
    
    await _prefs!.setStringList('test_results', results);
    notifyListeners();
  }

  Future<List<TestResult>> getRecentResults() async {
    if (_prefs == null) await init();
    List<String> results = _prefs!.getStringList('test_results') ?? [];
    return results.map((e) => TestResult.fromJson(jsonDecode(e))).toList();
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
}
