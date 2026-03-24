import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/file_service.dart';
import '../services/excel_service.dart';
import '../core/grade_parser_factory.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/custom_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Grades'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildUploadArea(),
                if (_selectedFile != null) ...[
                  const SizedBox(height: 24),
                  _buildFileInfo(),
                ],
                const Spacer(),
                if (_selectedFile != null && !_isUploading)
                  _buildProcessButton(context, state),
                if (_isUploading) const LoadingIndicator(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to upload Excel file',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: .xlsx, .xls',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedFile!.path.split('/').last,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedFile = null;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildProcessButton(BuildContext context, AppState state) {
    return CustomButton(
      text: 'Process Grades',
      icon: Icons.calculate,
      onPressed: () => _processFile(context, state),
    );
  }
  
  Future<void> _pickFile() async {
    final file = await FileService.pickExcelFile();
    if (file != null) {
      setState(() {
        _selectedFile = file;
      });
    }
  }
  
  Future<void> _processFile(BuildContext context, AppState state) async {
    if (_selectedFile == null) return;
    
    setState(() => _isUploading = true);
    
    try {
      final parser = GradeParserFactory.getParser('excel');
      final validation = parser.validateFile(_selectedFile!.path);
      
      if (!validation['valid']) {
        throw Exception(validation['error']);
      }
      
      final students = await parser.parseGrades(
        filePath: _selectedFile!.path,
        totalSubjects: state.totalSubjects,
        maxGrade: state.maxGrade,
      );
      
      state.setStudents(students);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully processed ${students.length} students'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }
}