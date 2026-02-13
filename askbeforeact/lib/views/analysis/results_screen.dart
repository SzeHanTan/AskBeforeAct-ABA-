import 'package:flutter/material.dart';
import '../../models/analysis_model.dart';

/// Screen displaying fraud analysis results
class ResultsScreen extends StatelessWidget {
  final AnalysisModel analysis;

  const ResultsScreen({
    Key? key,
    required this.analysis,
  }) : super(key: key);

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
                  
                  // Scam Type Card
                  _buildScamTypeCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Red Flags Card
                  if (analysis.redFlags.isNotEmpty) ...[
                    _buildRedFlagsCard(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Recommendations Card
                  if (analysis.recommendations.isNotEmpty) ...[
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

  Widget _buildRiskScoreCard() {
    final riskLevel = _getRiskLevel(analysis.riskScore);
    final riskColor = _getRiskColor(analysis.riskScore);
    final riskIcon = _getRiskIcon(analysis.riskScore);
    
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
            'Risk Score: ${analysis.riskScore}%',
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
              value: analysis.riskScore / 100,
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
                'Confidence: ${_formatConfidence(analysis.confidence)}',
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
              _getScamTypeIcon(analysis.scamType),
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
                  _formatScamType(analysis.scamType),
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
          
          ...analysis.redFlags.asMap().entries.map((entry) {
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
          }).toList(),
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
          
          ...analysis.recommendations.asMap().entries.map((entry) {
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
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Share functionality
            },
            icon: const Icon(Icons.share_outlined, size: 22),
            label: const Text(
              'Share',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF3B82F6),
              side: const BorderSide(
                color: Color(0xFF3B82F6),
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
}
