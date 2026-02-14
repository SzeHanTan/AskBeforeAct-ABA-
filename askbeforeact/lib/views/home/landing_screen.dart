import 'package:flutter/material.dart';

/// Landing page for the application
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              
              // Hero Section
              _buildHeroSection(context),
              
              const SizedBox(height: 80),
              
              // Features Section
              _buildFeaturesSection(),
              
              const SizedBox(height: 80),
              
              // How It Works Section
              _buildHowItWorksSection(),
              
              const SizedBox(height: 80),
              
              // CTA Section
              _buildCTASection(context),
              
              const SizedBox(height: 60),
              
              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified_user,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AskBeforeAct',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          // Navigation
          Row(
            children: [
              TextButton(
                onPressed: () {
                  // Scroll to about section or show about dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('About AskBeforeAct'),
                      content: const Text(
                        'AskBeforeAct is an AI-powered fraud detection platform that helps protect you from online scams. '
                        'We use advanced AI technology to analyze suspicious messages, emails, and websites in real-time.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/education');
                },
                child: const Text(
                  'Education',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/community');
                },
                child: const Text(
                  'Community',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/analyze');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 80),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            children: [
              // Left Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🛡️ Stay Safe Online',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Protect Yourself from\nOnline Fraud',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        height: 1.2,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Get instant AI-powered analysis of suspicious messages, emails, and websites. Simple, fast, and reliable fraud detection for everyone.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF64748B),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/analyze');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Analyze Now',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 22),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3B82F6),
                            side: const BorderSide(
                              color: Color(0xFF3B82F6),
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Learn More',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        _buildStatItem('10,000+', 'Analyses'),
                        const SizedBox(width: 48),
                        _buildStatItem('98%', 'Accuracy'),
                        const SizedBox(width: 48),
                        _buildStatItem('Free', 'Always'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 80),
              
              // Right Illustration
              Expanded(
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.security,
                      size: 200,
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'How We Protect You',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Simple, powerful tools to detect and prevent online fraud',
                style: TextStyle(
                  fontSize: 19,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.image_outlined,
                      'Screenshot Analysis',
                      'Upload suspicious screenshots for instant AI-powered fraud detection',
                      const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.text_fields,
                      'Text Analysis',
                      'Paste emails or messages to check for phishing and scam patterns',
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.link,
                      'URL Checking',
                      'Verify website safety before clicking suspicious links',
                      const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Simple as 1-2-3',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: _buildStep(
                      '1',
                      'Upload or Paste',
                      'Share the suspicious content you want to check',
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildStep(
                      '2',
                      'AI Analysis',
                      'Our AI scans for fraud patterns and red flags',
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _buildStep(
                      '3',
                      'Get Results',
                      'Receive clear recommendations on what to do next',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF64748B),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Ready to Stay Safe?',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Start analyzing suspicious content in seconds',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/analyze');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 22,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Started for Free',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Privacy Policy'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text('Terms of Service'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text('Contact Us'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 AskBeforeAct. All rights reserved.',
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
