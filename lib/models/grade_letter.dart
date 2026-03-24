import 'package:flutter/material.dart';

enum GradeLetter {
  A('A', 16.0, 20.0, Colors.green),
  B('B', 12.0, 15.99, Colors.lightGreen),
  C('C', 10.0, 11.99, Colors.orange),
  D('D', 8.0, 9.99, Colors.deepOrange),
  F('F', 0.0, 7.99, Colors.red);

  final String letter;
  final double minGrade;
  final double maxGrade;
  final Color color;

  const GradeLetter(this.letter, this.minGrade, this.maxGrade, this.color);

  static GradeLetter fromGrade(double grade) {
    return GradeLetter.values.firstWhere(
      (g) => grade >= g.minGrade && grade <= g.maxGrade,
      orElse: () => F,
    );
  }
}