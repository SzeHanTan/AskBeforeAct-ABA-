import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/analysis_model.dart';
import '../../services/image_generation_service.dart';
import '../../services/report_service.dart';

/// Screen displaying fraud analysis results
class ResultsScreen extends StatefulWidget {
  final AnalysisModel analysis;

  const ResultsScreen({
    super.key,
    required this.analysis,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ReportService _reportService = ReportService();
  bool _isDownloading = false;
  final ImageGenerationService _imageService = ImageGenerationService();
  Map<String, dynamic>? _generatedImage;
  bool _isGeneratingImage = false;
  String _selectedImageType = 'warning'; // 'warning', 'meme', 'social'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Risk Score Card
                  _buildRiskScoreCard(),
                  
                  const SizedBox(height: 24),
                  
                  // AI-Generated Image Card
                  _buildImageGenerationCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Scam Type Card
                  _buildScamTypeCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Red Flags Card
                  if (widget.analysis.redFlags.isNotEmpty) ...[
                    _buildRedFlagsCard(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Recommendations Card
                  if (widget.analysis.recommendations.isNotEmpty) ...[
                    _buildRecommendationsCard(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Action Buttons
                  _buildActionButtons(context),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build AI Image Generation Card
  Widget _buildImageGenerationCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'AI-Generated Warning',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Image type selector
          Row(
            children: [
              _buildImageTypeButton('Warning Image', 'warning', Icons.warning_amber),
              const SizedBox(width: 12),
              _buildImageTypeButton('Meme', 'meme', Icons.emoji_emotions),
              const SizedBox(width: 12),
              _buildImageTypeButton('Social Card', 'social', Icons.share),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Generated image or placeholder
          if (_generatedImage != null)
            _buildGeneratedImage()
          else if (_isGeneratingImage)
            _buildLoadingPlaceholder()
          else
            _buildGeneratePlaceholder(),
        ],
      ),
    );
  }
  
  Widget _buildImageTypeButton(String label, String type, IconData icon) {
    final isSelected = _selectedImageType == type;
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _selectedImageType = type;
            _generatedImage = null;
          });
        },
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF3B82F6) : Colors.white,
          foregroundColor: isSelected ? Colors.white : const Color(0xFF64748B),
          elevation: 0,
          side: BorderSide(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGeneratePlaceholder() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: const Color(0xFF3B82F6).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Generate AI-Powered Visual',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a shareable warning image',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _generateImage,
            icon: const Icon(Icons.auto_awesome, size: 20),
            label: const Text(
              'Generate Now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingPlaceholder() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF3B82F6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Creating your AI image...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This may take 5-10 seconds',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGeneratedImage() {
    try {
      final imageData = _generatedImage!['data'] as String;
      final imageBytes = base64Decode(imageData);
      
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.red.shade50,
                  child: const Center(
                    child: Text('Failed to load image'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _generateImage,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Regenerate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3B82F6),
                    side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement download/share
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      return Container(
        height: 300,
        color: Colors.red.shade50,
        child: Center(
          child: Text('Error displaying image: $e'),
        ),
      );
    }
  }
  
  Future<void> _generateImage() async {
    setState(() {
      _isGeneratingImage = true;
      _generatedImage = null;
    });
    
    try {
      Map<String, dynamic>? result;
      
      switch (_selectedImageType) {
        case 'warning':
          result = await _imageService.generateWarningImage(widget.analysis);
          break;
        case 'meme':
          result = await _imageService.generateEducationalMeme(widget.analysis);
          break;
        case 'social':
          result = await _imageService.generateSocialCard(widget.analysis);
          break;
      }
      
      setState(() {
        _generatedImage = result;
        _isGeneratingImage = false;
      });
      
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGeneratingImage = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRiskScoreCard() {
    final riskLevel = _getRiskLevel(widget.analysis.riskScore);
    final riskColor = _getRiskColor(widget.analysis.riskScore);
    final riskIcon = _getRiskIcon(widget.analysis.riskScore);
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Risk Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              riskIcon,
              size: 56,
              color: riskColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Risk Level Text
          Text(
            riskLevel.toUpperCase(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: riskColor,
              letterSpacing: 1.2,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Risk Score
          Text(
            'Risk Score: ${widget.analysis.riskScore}%',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Risk Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: widget.analysis.riskScore / 100,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(riskColor),
              minHeight: 16,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Confidence Level
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 20,
                color: const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                'Confidence: ${_formatConfidence(widget.analysis.confidence)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScamTypeCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getScamTypeIcon(widget.analysis.scamType),
              size: 32,
              color: const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detected Scam Type',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatScamType(widget.analysis.scamType),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedFlagsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 28,
                  color: const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Warning Signs Detected',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          ...widget.analysis.redFlags.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF334155),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 28,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'What You Should Do',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          ...widget.analysis.recommendations.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF334155),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isDownloading ? null : _downloadReport,
            icon: _isDownloading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download, size: 22),
            label: Text(
              _isDownloading ? 'Generating...' : 'Download Report',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.refresh, size: 22),
            label: const Text(
              'New Analysis',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  String _getRiskLevel(int score) {
    if (score <= 30) return 'Low Risk';
    if (score <= 70) return 'Medium Risk';
    return 'High Risk';
  }

  Color _getRiskColor(int score) {
    if (score <= 30) return const Color(0xFF10B981); // Green
    if (score <= 70) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFFEF4444); // Red
  }

  IconData _getRiskIcon(int score) {
    if (score <= 30) return Icons.check_circle_outline;
    if (score <= 70) return Icons.warning_amber_rounded;
    return Icons.dangerous_outlined;
  }

  IconData _getScamTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'phishing':
        return Icons.phishing_outlined;
      case 'romance':
        return Icons.favorite_border;
      case 'payment':
        return Icons.payment;
      case 'job':
        return Icons.work_outline;
      case 'tech_support':
        return Icons.support_agent;
      default:
        return Icons.report_problem_outlined;
    }
  }

  String _formatScamType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatConfidence(String confidence) {
    return confidence[0].toUpperCase() + confidence.substring(1);
  }
  
  /// Download PDF report for authorities
  Future<void> _downloadReport() async {
    setState(() {
      _isDownloading = true;
    });
    
    try {
      await _reportService.downloadReport(widget.analysis);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report downloaded successfully! You can now share it with authorities.'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download report: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }
}
