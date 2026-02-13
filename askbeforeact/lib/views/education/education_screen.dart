import 'package:flutter/material.dart';

/// Education hub screen
class EducationScreen extends StatelessWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Learn About Fraud',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Fraud Types',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn to recognize and protect yourself from these common scams',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildEducationCard(
                    '🎣 Phishing Emails',
                    'Fake emails pretending to be from legitimate companies',
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEducationCard(
                    '💔 Romance Scams',
                    'Fake online relationships designed to steal money',
                    const Color(0xFFEC4899),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEducationCard(
                    '💳 Payment Fraud',
                    'Unauthorized charges and fake payment requests',
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEducationCard(
                    '💼 Job Scams',
                    'Fake job offers and work-from-home schemes',
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildEducationCard(
                    '🔧 Tech Support Scams',
                    'Fake technical support claiming to fix your device',
                    const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                title.split(' ')[0],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(title.indexOf(' ') + 1),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}
