import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/analysis_model.dart';
import 'report_service_web.dart';

/// Service for generating downloadable fraud detection reports
class ReportService {
  /// Generate a professional PDF report for authorities
  Future<Uint8List> generateReport(AnalysisModel analysis) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormatter = DateFormat('MMMM dd, yyyy \'at\' HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          _buildHeader(),
          pw.SizedBox(height: 30),
          
          // Report Title
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: _getRiskColor(analysis.riskScore),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'FRAUD DETECTION REPORT',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Risk Level: ${analysis.riskLevel.toUpperCase()} (${analysis.riskScore}%)',
                  style: const pw.TextStyle(
                    fontSize: 16,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 20),
          
          // Report Metadata
          _buildMetadataSection(analysis, dateFormatter.format(now)),
          
          pw.SizedBox(height: 20),
          
          // Analysis Summary
          _buildSummarySection(analysis),
          
          pw.SizedBox(height: 20),
          
          // Red Flags Section
          if (analysis.redFlags.isNotEmpty)
            _buildRedFlagsSection(analysis.redFlags),
          
          pw.SizedBox(height: 20),
          
          // Recommendations Section
          if (analysis.recommendations.isNotEmpty)
            _buildRecommendationsSection(analysis.recommendations),
          
          pw.SizedBox(height: 20),
          
          // Content Analyzed
          _buildContentSection(analysis),
          
          pw.SizedBox(height: 30),
          
          // Footer
          _buildFooter(dateFormatter.format(now)),
        ],
      ),
    );

    return pdf.save();
  }
  
  /// Build report header
  pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'AskBeforeAct',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF3B82F6),
              ),
            ),
            pw.Text(
              'AI-Powered Fraud Detection',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: const PdfColor.fromInt(0xFF3B82F6), width: 2),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Text(
            'OFFICIAL REPORT',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF3B82F6),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Build metadata section
  pw.Widget _buildMetadataSection(AnalysisModel analysis, String date) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Report Information',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          _buildInfoRow('Report ID:', analysis.id.isNotEmpty ? analysis.id : 'Generated Report'),
          _buildInfoRow('Generated:', date),
          _buildInfoRow('Analysis Type:', _formatType(analysis.type)),
          _buildInfoRow('Confidence Level:', analysis.confidence.toUpperCase()),
        ],
      ),
    );
  }
  
  /// Build summary section
  pw.Widget _buildSummarySection(AnalysisModel analysis) {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Analysis Summary',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Detected Scam Type:', _formatScamType(analysis.scamType)),
                pw.SizedBox(height: 8),
                _buildInfoRow('Risk Assessment:', '${analysis.riskLevel.toUpperCase()} (${analysis.riskScore}/100)'),
                pw.SizedBox(height: 8),
                _buildInfoRow('AI Confidence:', '${analysis.confidence.toUpperCase()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build red flags section
  pw.Widget _buildRedFlagsSection(List<String> redFlags) {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 24,
                height: 24,
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFEF4444),
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    '!',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Text(
                'Warning Signs Detected',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFFEF2F2),
              border: pw.Border.all(color: const PdfColor.fromInt(0xFFEF4444)),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: redFlags.asMap().entries.map((entry) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${entry.key + 1}. ',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFFEF4444),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          entry.value,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            lineSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build recommendations section
  pw.Widget _buildRecommendationsSection(List<String> recommendations) {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 24,
                height: 24,
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF10B981),
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    '+',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Text(
                'Recommended Actions',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: const PdfColor.fromInt(0xFFF0FDF4),
              border: pw.Border.all(color: const PdfColor.fromInt(0xFF10B981)),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: recommendations.asMap().entries.map((entry) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '${entry.key + 1}. ',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF10B981),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          entry.value,
                          style: const pw.TextStyle(
                            fontSize: 11,
                            lineSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build content section
  pw.Widget _buildContentSection(AnalysisModel analysis) {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Content Analyzed',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              analysis.content.isNotEmpty 
                ? analysis.content 
                : 'Content not available for this analysis type.',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey800,
                lineSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build footer
  pw.Widget _buildFooter(String date) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 20),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey400, width: 1),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Important Notice',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'This report was generated by AskBeforeAct\'s AI-powered fraud detection system. '
            'While our system provides highly accurate analysis, we recommend verifying findings '
            'with relevant authorities. This report can be used as supporting evidence when '
            'reporting fraud to law enforcement or regulatory agencies.',
            style: const pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey700,
              lineSpacing: 1.4,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated: $date',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Text(
                'AskBeforeAct - Protecting You from Fraud',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Helper to build info rows
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }
  
  /// Get PDF color based on risk score
  PdfColor _getRiskColor(int score) {
    if (score >= 70) return const PdfColor.fromInt(0xFFEF4444); // Red
    if (score >= 40) return const PdfColor.fromInt(0xFFF59E0B); // Orange
    return const PdfColor.fromInt(0xFF10B981); // Green
  }
  
  /// Format scam type
  String _formatScamType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
  
  /// Format analysis type
  String _formatType(String type) {
    switch (type.toLowerCase()) {
      case 'screenshot':
        return 'Image/Screenshot Analysis';
      case 'text':
        return 'Text Content Analysis';
      case 'url':
        return 'URL Safety Check';
      default:
        return type.toUpperCase();
    }
  }
  
  /// Download the report (Web-compatible)
  Future<void> downloadReport(AnalysisModel analysis) async {
    try {
      final pdfData = await generateReport(analysis);
      final fileName = 'fraud_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      // Use web-specific downloader
      await ReportDownloader.download(pdfData, fileName);
    } catch (e) {
      throw Exception('Failed to download report: $e');
    }
  }
}
