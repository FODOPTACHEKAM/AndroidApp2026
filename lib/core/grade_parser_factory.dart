import 'abstract_grade_parser.dart';
import '../services/excel_service.dart';

class GradeParserFactory {
  static const Map<String, AbstractGradeParser> _parsers = {
    'excel': ExcelService(),
  };
  
  const GradeParserFactory._();
  
  static AbstractGradeParser getParser(String fileType) {
    final parser = _parsers[fileType.toLowerCase()];
    if (parser == null) {
      throw Exception('No parser available for file type: $fileType');
    }
    return parser;
  }
  
  static List<String> getSupportedFormats() => _parsers.keys.toList();
}