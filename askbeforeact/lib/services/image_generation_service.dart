import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/env_config.dart';
import '../models/analysis_model.dart';

/// Service for generating visual content based on fraud analysis
class ImageGenerationService {
  /// Generate a warning meme/image based on analysis results
  Future<Map<String, dynamic>?> generateWarningImage(AnalysisModel analysis) async {
    try {
      // Create a prompt for image generation based on the scam type
      final prompt = _createImagePrompt(analysis);
      
      print('🎨 Generating warning image for ${analysis.scamType}...');
      
      // Use Gemini's image generation model
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key=${EnvConfig.geminiApiKey}'
      );
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        }),
      );
      
      print('📡 Image generation response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Image generated successfully!');
        return _extractImageData(data);
      } else {
        print('❌ Image generation failed: ${response.body}');
      }
      
      return null;
    } catch (e) {
      print('❌ Error generating warning image: $e');
      return null;
    }
  }
  
  /// Generate a shareable social media card
  Future<Map<String, dynamic>?> generateSocialCard(AnalysisModel analysis) async {
    final prompt = '''
Create a shareable social media warning card image:
- Bold text at top: "⚠️ SCAM ALERT"
- Scam type in large text: ${analysis.scamType.toUpperCase()}
- Risk level badge: ${analysis.riskLevel.toUpperCase()}
- Main warning message: "${analysis.redFlags.isNotEmpty ? analysis.redFlags.first : 'Be careful!'}"
- Style: Modern, eye-catching, professional, Instagram-ready
- Colors: Red and yellow gradient for warning
- Include: Large shield icon or warning symbol
- Background: Dark with bright accents
- Size: Square format (1080x1080) for social media
''';
    
    return await _generateImage(prompt);
  }
  
  /// Generate an educational meme
  Future<Map<String, dynamic>?> generateEducationalMeme(AnalysisModel analysis) async {
    final memePrompt = _createMemePrompt(analysis);
    return await _generateImage(memePrompt);
  }
  
  /// Create image generation prompt based on analysis
  String _createImagePrompt(AnalysisModel analysis) {
    final scamType = analysis.scamType;
    final riskLevel = analysis.riskLevel;
    
    switch (scamType.toLowerCase()) {
      case 'phishing':
        return '''
Create a warning image for a PHISHING scam:
- Show a fishing hook with an email icon
- Red warning colors
- Text: "Don't Take the Bait!"
- Risk Level: $riskLevel
- Style: Modern, bold, attention-grabbing
''';
      
      case 'romance':
        return '''
Create a warning image for a ROMANCE scam:
- Show a broken heart with a dollar sign
- Pink and red colors with warning elements
- Text: "Love Shouldn't Cost Money"
- Risk Level: $riskLevel
- Style: Emotional but clear warning
''';
      
      case 'payment':
        return '''
Create a warning image for a PAYMENT scam:
- Show a credit card with a red X
- Red and black colors
- Text: "Stop! Verify Before You Pay"
- Risk Level: $riskLevel
- Style: Bold, urgent, professional
''';
      
      case 'job':
        return '''
Create a warning image for a JOB scam:
- Show a briefcase with a warning symbol
- Yellow and red warning colors
- Text: "Real Jobs Don't Ask for Money"
- Risk Level: $riskLevel
- Style: Professional, clear warning
''';
      
      case 'tech_support':
        return '''
Create a warning image for a TECH SUPPORT scam:
- Show a computer with a fake warning popup
- Red alert colors
- Text: "Microsoft Won't Call You!"
- Risk Level: $riskLevel
- Style: Tech-themed, urgent warning
''';
      
      case 'investment':
        return '''
Create a warning image for an INVESTMENT scam:
- Show money with a trap or scam symbol
- Gold and red colors
- Text: "If It's Too Good to Be True..."
- Risk Level: $riskLevel
- Style: Financial, serious warning
''';
      
      case 'lottery':
        return '''
Create a warning image for a LOTTERY scam:
- Show lottery tickets with a red X
- Bright colors with warning overlay
- Text: "You Can't Win What You Didn't Enter"
- Risk Level: $riskLevel
- Style: Bold, clear, attention-grabbing
''';
      
      default:
        return '''
Create a general SCAM WARNING image:
- Show a shield with a warning symbol
- Red and yellow alert colors
- Text: "⚠️ SCAM DETECTED"
- Risk Level: $riskLevel
- Style: Universal warning, professional
''';
    }
  }
  
  /// Create meme-style prompt
  String _createMemePrompt(AnalysisModel analysis) {
    final scamType = analysis.scamType;
    
    final memeTemplates = {
      'phishing': '''
Create a meme-style image:
- Top text: "SCAMMERS: Send suspicious email"
- Bottom text: "ME: *Uses AskBeforeAct* 🛡️"
- Image: Person blocking/rejecting something
- Style: Popular meme format, humorous but educational
''',
      'romance': '''
Create a meme-style image:
- Top text: "SCAMMER: I love you, send money"
- Bottom text: "AskBeforeAct: That's a scam"
- Image: Person seeing through deception
- Style: Relatable, humorous, protective
''',
      'payment': '''
Create a meme-style image:
- Top text: "SCAMMER: Pay now or else!"
- Bottom text: "ME: *Checks with AskBeforeAct first* 😎"
- Image: Confident person avoiding trap
- Style: Empowering, humorous
''',
    };
    
    return memeTemplates[scamType] ?? '''
Create a general anti-scam meme:
- Top text: "SCAMMERS: Try to trick me"
- Bottom text: "ASKBEFOREACT: Not today! 🛡️"
- Image: Person protected by shield
- Style: Empowering, humorous, shareable
''';
  }
  
  /// Generic image generation method
  Future<Map<String, dynamic>?> _generateImage(String prompt) async {
    try {
      print('🎨 Generating image...');
      
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent?key=${EnvConfig.geminiApiKey}'
      );
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        }),
      );
      
      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Image generated!');
        return _extractImageData(data);
      } else {
        print('❌ Failed: ${response.body}');
      }
      
      return null;
    } catch (e) {
      print('❌ Error generating image: $e');
      return null;
    }
  }
  
  /// Extract image data from API response
  Map<String, dynamic>? _extractImageData(Map<String, dynamic> data) {
    try {
      // Extract base64 image data or URL from response
      final candidates = data['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts != null && parts.isNotEmpty) {
          // Look for image data in the response
          for (var part in parts) {
            if (part['inlineData'] != null) {
              final imageData = part['inlineData']['data'] as String?;
              final mimeType = part['inlineData']['mimeType'] as String?;
              
              if (imageData != null) {
                return {
                  'data': imageData,
                  'mimeType': mimeType ?? 'image/png',
                };
              }
            }
          }
        }
      }
      
      print('⚠️ No image data found in response');
      return null;
    } catch (e) {
      print('❌ Error extracting image data: $e');
      return null;
    }
  }
  
  /// Generate a simple text-based visual representation (fallback)
  String generateTextVisual(AnalysisModel analysis) {
    final riskEmoji = _getRiskEmoji(analysis.riskScore);
    final scamEmoji = _getScamEmoji(analysis.scamType);
    
    return '''
$riskEmoji $scamEmoji SCAM ALERT $scamEmoji $riskEmoji

Risk Level: ${analysis.riskLevel.toUpperCase()}
Score: ${analysis.riskScore}/100

Type: ${_formatScamType(analysis.scamType)}

⚠️ WARNING SIGNS:
${analysis.redFlags.map((flag) => '• $flag').join('\n')}

✅ WHAT TO DO:
${analysis.recommendations.map((rec) => '• $rec').join('\n')}

🛡️ Stay Safe with AskBeforeAct!
''';
  }
  
  String _getRiskEmoji(int score) {
    if (score >= 70) return '🚨';
    if (score >= 40) return '⚠️';
    return '✅';
  }
  
  String _getScamEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'phishing': return '🎣';
      case 'romance': return '💔';
      case 'payment': return '💳';
      case 'job': return '💼';
      case 'tech_support': return '💻';
      case 'investment': return '💰';
      case 'lottery': return '🎰';
      default: return '⚠️';
    }
  }
  
  String _formatScamType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
