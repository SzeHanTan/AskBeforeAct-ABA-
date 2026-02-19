import 'dart:typed_data';
import 'dart:html' as html;

/// Web-specific implementation for downloading PDF reports
class ReportDownloader {
  static Future<void> download(Uint8List pdfData, String fileName) async {
    try {
      // Create blob and download link
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Create anchor element and trigger download
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      
      // Clean up
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Failed to download PDF: $e');
    }
  }
}
