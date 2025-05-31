import 'package:flutter/material.dart';

class AvatarUtils {
  static final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
  ];

  static Color getRandomColor(String seed) {
    final index = seed.hashCode.abs() % _colors.length;
    return _colors[index];
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static String getRandomAvatarUrl(String seed) {
    // Using DiceBear API for random avatars
    final styles = ['adventurer', 'avataaars', 'bottts', 'pixel-art'];
    final style = styles[seed.hashCode.abs() % styles.length];
    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed';
  }
} 