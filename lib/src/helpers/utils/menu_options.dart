import 'package:flutter/material.dart';

class MenuOptions {
  static final List<Map<String, dynamic>> topics = [
    {
      'id': 4,
      'title': 'Adjetivos',
      'icon': Icons.favorite,
      'color': Colors.pinkAccent
    },
    {
      'id': 6,
      'title': 'Adverbios de Frecuencia',
      'icon': Icons.timelapse,
      'color': Colors.indigoAccent
    },
    {
      'id': 5,
      'title': 'Preguntas',
      'icon': Icons.help_outline,
      'color': Colors.teal
    },
    {
      'id': 3,
      'title': 'Sustantivos',
      'icon': Icons.auto_stories,
      'color': Colors.blueAccent
    },
    {
      'id': 7,
      'title': 'Tiempos Verbales',
      'icon': Icons.access_time_filled,
      'color': Colors.deepOrangeAccent
    },
    {
      'id': 2,
      'title': 'Verbos Irregulares',
      'icon': Icons.directions_walk,
      'color': Colors.purpleAccent
    },
    {
      'id': 1,
      'title': 'Verbos Regulares',
      'icon': Icons.directions_run,
      'color': Colors.orangeAccent
    },
  ];

  static final List<Map<String, dynamic>> units = [
    {
      'id': 16,
      'title': 'Colorful memories',
      'icon': Icons.photo_album_rounded,
      'color': Colors.pink
    },
    {
      'id': 8,
      'title': 'Come In',
      'icon': Icons.home_rounded,
      'color': Colors.cyan
    },
    {
      'id': 15,
      'title': 'Get ready',
      'icon': Icons.event_rounded,
      'color': Colors.purple
    },
    {
      'id': 9,
      'title': 'I Love It!',
      'icon': Icons.favorite_rounded,
      'color': Colors.pinkAccent
    },
    {
      'id': 10,
      'title': 'Mondays and fun days',
      'icon': Icons.calendar_today_rounded,
      'color': Colors.teal
    },
    {
      'id': 12,
      'title': 'Now is good',
      'icon': Icons.access_time_rounded,
      'color': Colors.orange
    },
    {
      'id': 14,
      'title': 'Places to go',
      'icon': Icons.place_rounded,
      'color': Colors.deepOrange
    },
    {
      'id': 17,
      'title': 'Stop, eat, go',
      'icon': Icons.restaurant_rounded,
      'color': Colors.brown
    },
    {
      'id': 13,
      'title': 'You\'re good!',
      'icon': Icons.thumb_up_rounded,
      'color': Colors.lime
    },
    {
      'id': 11,
      'title': 'Zoom in, zoom out',
      'icon': Icons.map_rounded,
      'color': Colors.indigoAccent
    },
  ];

  // Helper getter to combine both lists if needed for flattened view
  static List<Map<String, dynamic>> get all => [...topics, ...units];
}
