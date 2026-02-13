import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';

/// Main analysis screen for fraud detection
class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({Key? key}) : super(key: key);

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  
  Uint8List? _selectedImageBytes;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedImageBytes = file.bytes;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _analyzeContent() {
    setState(() {
      _isAnalyzing = true;
    });

    // TODO: Implement actual analysis logic
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
      });
      _showSuccessSnackBar('Analysis completed!');
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  
                  // Header
                  Text(
                    'Fraud Detection Analysis',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A2332),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload a screenshot or paste suspicious content for instant AI-powered analysis',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Main Card
                  Container(
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
                        // Tab Bar
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xFF3B82F6),
                            unselectedLabelColor: const Color(0xFF64748B),
                            labelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            indicatorColor: const Color(0xFF3B82F6),
                            indicatorWeight: 3,
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.image_outlined, size: 24),
                                text: 'Screenshot Upload',
                              ),
                              Tab(
                                icon: Icon(Icons.text_fields, size: 24),
                                text: 'Text Input',
                              ),
                              Tab(
                                icon: Icon(Icons.link, size: 24),
                                text: 'URL Check',
                              ),
                            ],
                          ),
                        ),
                        
                        // Tab Content
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildScreenshotTab(),
                              _buildTextTab(),
                              _buildUrlTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreenshotTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Upload Area
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: _selectedImageBytes != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _selectedImageBytes!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedImageBytes = null;
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            size: 40,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Drag & Drop Screenshot',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'or click to browse',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Supports: JPG, PNG, PDF (Max 10MB)',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Analyze Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedImageBytes != null && !_isAnalyzing
                  ? _analyzeContent
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.analytics_outlined, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Analyze Screenshot',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paste Suspicious Text',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Copy and paste any suspicious email, message, or text content',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          
          // Text Input
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              expands: true,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Paste your text here...',
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 16,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFF3B82F6),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Analyze Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _textController.text.isNotEmpty && !_isAnalyzing
                  ? _analyzeContent
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.analytics_outlined, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Analyze Text',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlTab() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Website URL',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter a website URL to check if it\'s safe or potentially fraudulent',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          
          // URL Input
          TextField(
            controller: _urlController,
            style: const TextStyle(fontSize: 17),
            decoration: InputDecoration(
              hintText: 'https://example.com',
              hintStyle: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 17,
              ),
              prefixIcon: const Icon(
                Icons.link,
                color: Color(0xFF64748B),
                size: 24,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFBAE6FD),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF0284C7),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'We\'ll check the URL for known phishing patterns, suspicious domains, and security issues.',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xFF0C4A6E),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Analyze Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _urlController.text.isNotEmpty && !_isAnalyzing
                  ? _analyzeContent
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.analytics_outlined, size: 22),
                        SizedBox(width: 12),
                        Text(
                          'Check URL Safety',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
