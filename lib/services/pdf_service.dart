import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../core/file_exporter.dart';
import '../utils/constants.dart';

class PdfService extends FileExporter {
  const PdfService();
  
  @override
  Future<String> export({
    required Map<String, double> results,
    required String format,
  }) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(),
          _buildTable(results),
          _buildFooter(results),
        ],
      ),
    );
    
    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/grades_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    
    return filePath;
  }
  
  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          AppConstants.appName,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Grade Report',
          style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
        ),
        pw.Divider(),
        pw.SizedBox(height: 20),
      ],
    );
  }
  
  pw.Widget _buildTable(Map<String, double> results) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildTableCell('Student Name', isHeader: true),
            _buildTableCell('Average', isHeader: true),
            _buildTableCell('Grade', isHeader: true),
          ],
        ),
        ...results.entries.map(
          (entry) => pw.TableRow(
            children: [
              _buildTableCell(entry.key),
              _buildTableCell(entry.value.toStringAsFixed(2)),
              _buildTableCell(_getGradeLetter(entry.value)),
            ],
          ),
        ),
      ],
    );
  }
  
  pw.Widget _buildFooter(Map<String, double> results) {
    final classAverage = results.values.fold(0.0, (sum, avg) => sum + avg) / results.length;
    
    return pw.Column(
      children: [
        pw.SizedBox(height: 30),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Class Average:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(classAverage.toStringAsFixed(2)),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Generated on ${DateTime.now().toString().split(' ')[0]}',
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
        ),
      ],
    );
  }
  
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(12),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
  
  String _getGradeLetter(double average) {
    if (average >= 16) return 'A';
    if (average >= 12) return 'B';
    if (average >= 10) return 'C';
    if (average >= 8) return 'D';
    return 'F';
  }
  
  @override
  String getFileExtension() => 'pdf';
}