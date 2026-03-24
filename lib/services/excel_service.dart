import 'dart:io';
import 'package:excel/excel.dart';
import '../core/abstract_grade_parser.dart';
import '../models/student.dart';
import '../models/grade.dart';

class ExcelService extends AbstractGradeParser {
  const ExcelService();
  
  @override
  Future<List<Student>> parseGrades({
    required String filePath,
    required int totalSubjects,
    required double maxGrade,
  }) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null) return [];
    
    final students = <Student>[];
    
    for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
      final row = sheet.rows[rowIndex];
      if (row.isEmpty) continue;
      
      final name = row[0]?.value?.toString() ?? '';
      if (name.isEmpty) continue;
      
      final grades = <Grade>[];
      
      for (var colIndex = 2; colIndex < row.length && colIndex < totalSubjects + 2; colIndex++) {
        final gradeValue = _parseGradeValue(row[colIndex]?.value);
        final subjectName = sheet.rows[0][colIndex]?.value?.toString() ?? 'Subject ${colIndex - 1}';
        
        if (gradeValue != null) {
          grades.add(Grade(
            subject: subjectName,
            value: gradeValue,
            coefficient: 1.0,
          ));
        }
      }
      
      if (grades.isNotEmpty) {
        students.add(Student(
          id: 'S${students.length + 1}',
          name: name,
          grades: grades,
        ));
      }
    }
    
    return students;
  }
  
  double? _parseGradeValue(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed != null && parsed >= 0 && parsed <= 20 ? parsed : null;
    }
    return null;
  }
  
  @override
  Map<String, dynamic> validateFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return {'valid': false, 'error': 'File does not exist'};
    }
    
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      
      if (excel.tables.isEmpty) {
        return {'valid': false, 'error': 'Excel file is empty'};
      }
      
      return {'valid': true};
    } catch (e) {
      return {'valid': false, 'error': 'Invalid Excel file format'};
    }
  }
  
  @override
  List<String> getRequiredColumns() => ['Nom', 'Matière', 'Note'];
}