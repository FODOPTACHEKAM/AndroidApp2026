abstract class FileExporter {
  const FileExporter();
  
  Future<String> export({
    required Map<String, double> results,
    required String format,
  });
  
  String getFileExtension();
}