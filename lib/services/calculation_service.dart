import '../models/student.dart';

class CalculationService {
  const CalculationService._();
  
  static Map<String, double> calculateAverages(
    List<Student> students,
    int totalSubjects,
  ) {
    return Map.fromEntries(
      students.map(
        (student) => MapEntry(
          student.name,
          student.calculateAverage(totalSubjects),
        ),
      ),
    );
  }
  
  static Map<String, String> getGradeLetters(Map<String, double> averages) {
    return Map.fromEntries(
      averages.entries.map(
        (entry) => MapEntry(
          entry.key,
          _getGradeLetter(entry.value),
        ),
      ),
    );
  }
  
  static String _getGradeLetter(double average) {
    if (average >= 16) return 'A';
    if (average >= 12) return 'B';
    if (average >= 10) return 'C';
    if (average >= 8) return 'D';
    return 'F';
  }
  
  static double calculateClassAverage(Map<String, double> averages) {
    if (averages.isEmpty) return 0.0;
    final total = averages.values.fold(0.0, (sum, avg) => sum + avg);
    return total / averages.length;
  }
}