import '../models/student.dart';

abstract class AbstractGradeParser {
  const AbstractGradeParser();
  
  Future<List<Student>> parseGrades({
    required String filePath,
    required int totalSubjects,
    required double maxGrade,
  });
  
  Map<String, dynamic> validateFile(String filePath);
  
  List<String> getRequiredColumns();
}