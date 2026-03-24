import 'grade.dart';

class Student {
  final String id;
  final String name;
  final List<Grade> grades;
  
  const Student({
    required this.id,
    required this.name,
    required this.grades,
  });
  
  double calculateAverage(int totalSubjects) {
    if (grades.isEmpty) return 0.0;
    
    final totalPoints = grades.fold<double>(
      0.0,
      (sum, grade) => sum + (grade.value * grade.coefficient),
    );
    
    final totalCoefficients = grades.fold<double>(
      0.0,
      (sum, grade) => sum + grade.coefficient,
    );
    
    return totalCoefficients > 0 ? totalPoints / totalCoefficients : 0.0;
  }
  
  Student copyWith({
    String? id,
    String? name,
    List<Grade>? grades,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      grades: grades ?? this.grades,
    );
  }
}