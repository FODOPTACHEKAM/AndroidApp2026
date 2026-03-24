import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Grade Calculator Pro';
  static const String appDescription = 'Professional grade calculation for educators';
  static const Color primaryColor = Color(0xFF667eea);
  static const Color secondaryColor = Color(0xFF764ba2);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  
  static const double defaultMaxGrade = 20.0;
  static const int defaultTotalSubjects = 10;
  
  static const Map<String, String> gradeLetters = {
    'A': 'Excellent (16-20)',
    'B': 'Very Good (12-15.99)',
    'C': 'Good (10-11.99)',
    'D': 'Satisfactory (8-9.99)',
    'F': 'Needs Improvement (0-7.99)',
  };
}