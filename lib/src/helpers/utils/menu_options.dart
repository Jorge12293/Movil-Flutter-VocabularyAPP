import 'package:flutter/material.dart';

class MenuOptions {
  static final List<Map<String, dynamic>> list = [
    {
      'id': 1,
      'title': 'Verbos Regulares',
      'icon': Icons.directions_run,
      'color': Colors.orangeAccent
    },
    {
      'id': 2,
      'title': 'Verbos Irregulares',
      'icon': Icons.directions_walk,
      'color': Colors.purpleAccent
    },
    {
      'id': 3,
      'title': 'Sustantivos',
      'icon': Icons.auto_stories,
      'color': Colors.blueAccent
    },
    {
      'id': 4,
      'title': 'Adjetivos',
      'icon': Icons.favorite,
      'color': Colors.pinkAccent
    },
    {
      'id': 5,
      'title': 'Preguntas',
      'icon': Icons.help_outline,
      'color': Colors.teal
    },
    {
      'id': 6,
      'title': 'Adverbios de Frecuencia',
      'icon': Icons.timelapse,
      'color': Colors.indigoAccent
    },
  ];

  /// Helper to get navigation args or route name if we were using named routes.
  /// For now, just a simple list.
}
