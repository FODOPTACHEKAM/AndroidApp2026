import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  const FileService._();
  
  static Future<File?> pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      allowMultiple: false,
    );
    
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
  
  static Future<void> shareFile(String filePath) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Here are the grade calculation results',
    );
  }
  
  static Future<String> saveToDownloads(String sourcePath, String fileName) async {
    final directory = await getDownloadsDirectory();
    if (directory == null) return sourcePath;
    
    final destinationPath = '${directory.path}/$fileName';
    final sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);
    
    return destinationPath;
  }
  
  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Silent fail for temporary files
    }
  }
}