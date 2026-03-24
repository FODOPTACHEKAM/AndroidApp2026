import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/pdf_service.dart';
import '../services/file_service.dart';
import '../widgets/grade_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Results'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _exportPDF(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSummaryCard(context),
              Expanded(
                child: _buildResultsList(context),
              ),
              _buildExportButtons(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSummaryCard(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final results = state.calculateResults();
    final classAverage = state.getClassAverage();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Class Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Students',
                results.length.toString(),
                Icons.people,
              ),
              _buildStatItem(
                'Class Average',
                classAverage.toStringAsFixed(2),
                Icons.analytics,
              ),
              _buildStatItem(
                'Subjects',
                state.totalSubjects.toString(),
                Icons.book,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF667eea), size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
  
  Widget _buildResultsList(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final results = state.calculateResults();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final entry = results.entries.elementAt(index);
        return GradeCard(
          studentName: entry.key,
          average: entry.value,
        );
      },
    );
  }
  
  Widget _buildExportButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Export PDF',
              icon: Icons.picture_as_pdf,
              onPressed: () => _exportPDF(context),
              isOutlined: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: 'New Calculation',
              icon: Icons.refresh,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _exportPDF(BuildContext context) async {
    final state = Provider.of<AppState>(context, listen: false);
    final results = state.calculateResults();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: LoadingIndicator()),
    );
    
    try {
      final pdfService = const PdfService();
      final filePath = await pdfService.export(results: results, format: 'pdf');
      
      Navigator.pop(context);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Successful'),
          content: const Text('PDF has been generated successfully. Would you like to share it?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await FileService.shareFile(filePath);
              },
              child: const Text('Share'),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}