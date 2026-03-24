import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/calculation_service.dart';

class AppState extends ChangeNotifier {
  List<Student> _students = [];
  int _totalSubjects = 10;
  double _maxGrade = 20.0;
  bool _isLoading = false;
  String? _error;
  
  List<Student> get students => _students;
  int get totalSubjects => _totalSubjects;
  double get maxGrade => _maxGrade;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  void setTotalSubjects(int subjects) {
    _totalSubjects = subjects;
    notifyListeners();
  }
  
  void setMaxGrade(double maxGrade) {
    _maxGrade = maxGrade;
    notifyListeners();
  }
  
  void setStudents(List<Student> students) {
    _students = students;
    _error = null;
    notifyListeners();
  }
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
  
  Map<String, double> calculateResults() {
    return CalculationService.calculateAverages(_students, _totalSubjects);
  }
  
  double getClassAverage() {
    final results = calculateResults();
    return CalculationService.calculateClassAverage(results);
  }
  
  void clear() {
    _students = [];
    _error = null;
    notifyListeners();
  }
}