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
    // Get specific details from the analysis
    final mainRedFlag = analysis.redFlags.isNotEmpty 
        ? analysis.redFlags.first 
        : 'Be careful!';
    final secondaryRedFlag = analysis.redFlags.length > 1
        ? analysis.redFlags[1]
        : '';
    final keyRecommendation = analysis.recommendations.isNotEmpty
        ? analysis.recommendations.first
        : 'Stay vigilant';
    
    final prompt = '''
Create a shareable social media warning card image based on THIS SPECIFIC SCAM:

SPECIFIC DETAILS:
- Main Red Flag: "$mainRedFlag"
${secondaryRedFlag.isNotEmpty ? '- Secondary Red Flag: "$secondaryRedFlag"' : ''}
- Key Action: "$keyRecommendation"
- Risk Score: ${analysis.riskScore}/100

VISUAL DESIGN:
- Bold text at top: "⚠️ SCAM ALERT"
- Scam type in large text: ${analysis.scamType.toUpperCase()}
- Risk level badge: ${analysis.riskLevel.toUpperCase()} (${analysis.riskScore}/100)
- Main warning message (specific): "$mainRedFlag"
- Call to action: "$keyRecommendation"
- Style: Modern, eye-catching, professional, Instagram-ready
- Colors: Red and yellow gradient for warning
- Include: Large shield icon or warning symbol specific to ${analysis.scamType}
- Background: Dark with bright accents
- Size: Square format (1080x1080) for social media
- Add: "Detected by AskBeforeAct" badge at bottom

Make this card SPECIFIC to this scam case, not generic. Include the actual red flag detected.
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
    
    // Extract specific details from the analysis
    final primaryRedFlag = analysis.redFlags.isNotEmpty 
        ? analysis.redFlags.first 
        : 'Suspicious activity detected';
    final topRecommendation = analysis.recommendations.isNotEmpty
        ? analysis.recommendations.first
        : 'Verify before taking action';
    
    // Get a snippet of the actual content (first 100 chars for context)
    final contentSnippet = analysis.content.length > 100
        ? analysis.content.substring(0, 100)
        : analysis.content;
    
    // Create a more specific, personalized prompt
    final baseContext = '''
SPECIFIC CONTEXT FROM USER'S CASE:
- Content Preview: "$contentSnippet"
- Main Red Flag: "$primaryRedFlag"
- Key Recommendation: "$topRecommendation"
- Risk Score: ${analysis.riskScore}/100
- Confidence: ${analysis.confidence}
''';
    
    switch (scamType.toLowerCase()) {
      case 'phishing':
        return '''
Create a warning image for a PHISHING scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a fishing hook with an email/message icon
- Red warning colors with urgent styling
- Main Text: "Don't Take the Bait!"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Modern, bold, attention-grabbing, personalized to this specific phishing attempt

Make it clear this is about THIS specific phishing attempt, not a generic warning.
''';
      
      case 'romance':
        return '''
Create a warning image for a ROMANCE scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a broken heart with a dollar sign or money trap
- Pink and red colors with warning elements
- Main Text: "Love Shouldn't Cost Money"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Emotional but clear warning, personalized to this specific romance scam

Reference the specific red flag detected in this case to make it personal.
''';
      
      case 'payment':
        return '''
Create a warning image for a PAYMENT scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a credit card with a red X or blocked payment
- Red and black colors with urgent styling
- Main Text: "Stop! Verify Before You Pay"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Bold, urgent, professional, specific to this payment request

Highlight the specific suspicious payment request from this case.
''';
      
      case 'job':
        return '''
Create a warning image for a JOB scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a briefcase with a warning symbol or trap
- Yellow and red warning colors
- Main Text: "Real Jobs Don't Ask for Money"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Professional, clear warning, specific to this job offer

Reference the specific suspicious job offer details from this case.
''';
      
      case 'tech_support':
        return '''
Create a warning image for a TECH SUPPORT scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a computer with a fake warning popup or scam call
- Red alert colors with tech theme
- Main Text: "Microsoft Won't Call You!"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Tech-themed, urgent warning, specific to this tech support scam

Show elements specific to THIS tech support scam attempt.
''';
      
      case 'investment':
        return '''
Create a warning image for an INVESTMENT scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show money with a trap, pyramid, or scam symbol
- Gold and red colors with warning overlay
- Main Text: "If It's Too Good to Be True..."
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Financial, serious warning, specific to this investment scheme

Reference the specific investment promise or scheme from this case.
''';
      
      case 'lottery':
        return '''
Create a warning image for a LOTTERY scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show lottery tickets with a red X or fake prize
- Bright colors with warning overlay
- Main Text: "You Can't Win What You Didn't Enter"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Bold, clear, attention-grabbing, specific to this lottery scam

Show the specific fake lottery or prize claim from this case.
''';
      
      case 'impersonation':
        return '''
Create a warning image for an IMPERSONATION scam based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a mask or fake identity symbol
- Red and orange warning colors
- Main Text: "Verify Identity Before Trusting"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Clear, professional, specific to this impersonation attempt

Show who is being impersonated in THIS specific case.
''';
      
      default:
        return '''
Create a SCAM WARNING image based on this SPECIFIC case:

$baseContext

Visual Elements:
- Show a shield with a warning symbol
- Red and yellow alert colors
- Main Text: "⚠️ SCAM DETECTED"
- Include specific warning: "$primaryRedFlag"
- Risk Level Badge: $riskLevel (${analysis.riskScore}/100)
- Style: Universal warning, professional, personalized to this specific scam

Make it clear this is about THIS specific scam attempt with the detected red flags.
''';
    }
  }
  
  /// Create meme-style prompt
  String _createMemePrompt(AnalysisModel analysis) {
    final scamType = analysis.scamType;
    
    // Get specific details to personalize the meme
    final specificRedFlag = analysis.redFlags.isNotEmpty 
        ? analysis.redFlags.first 
        : 'suspicious message';
    
    // Extract a key phrase from the red flag for the meme
    String scammerQuote = _extractScammerQuote(specificRedFlag, scamType);
    
    final memeTemplates = {
      'phishing': '''
Create a meme-style image based on THIS SPECIFIC phishing attempt:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "SCAMMER: $scammerQuote"
- Bottom text: "ME: *Uses AskBeforeAct* 🛡️ NOPE!"
- Image: Person confidently blocking/rejecting email
- Style: Popular meme format, humorous but educational
- Include subtle reference to the specific red flag

Make it relatable to THIS specific phishing attempt.
''',
      'romance': '''
Create a meme-style image based on THIS SPECIFIC romance scam:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "SCAMMER: $scammerQuote"
- Bottom text: "ASKBEFOREACT: 🚩 That's a scam!"
- Image: Person seeing through romantic deception
- Style: Relatable, humorous, protective
- Include reference to the specific red flag

Make it personal to THIS romance scam attempt.
''',
      'payment': '''
Create a meme-style image based on THIS SPECIFIC payment scam:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "SCAMMER: $scammerQuote"
- Bottom text: "ME: *Checks AskBeforeAct first* 😎 SAVED!"
- Image: Confident person avoiding payment trap
- Style: Empowering, humorous
- Include reference to the specific suspicious payment request

Make it specific to THIS payment scam.
''',
      'job': '''
Create a meme-style image based on THIS SPECIFIC job scam:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "FAKE JOB: $scammerQuote"
- Bottom text: "ASKBEFOREACT: 🚫 Real jobs don't do that!"
- Image: Person rejecting fake job offer
- Style: Professional but humorous
- Include reference to the specific job scam tactic

Make it specific to THIS job scam.
''',
      'investment': '''
Create a meme-style image based on THIS SPECIFIC investment scam:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "SCAMMER: $scammerQuote"
- Bottom text: "ME: If it's too good to be true... 🛡️"
- Image: Person avoiding investment trap
- Style: Smart, humorous, financially savvy
- Include reference to the specific investment promise

Make it specific to THIS investment scam.
''',
    };
    
    return memeTemplates[scamType] ?? '''
Create an anti-scam meme based on THIS SPECIFIC case:

SPECIFIC CONTEXT:
- Red Flag Detected: "$specificRedFlag"
- Scammer's Tactic: "$scammerQuote"

MEME FORMAT:
- Top text: "SCAMMER: $scammerQuote"
- Bottom text: "ASKBEFOREACT: Not today! 🛡️"
- Image: Person protected by shield, avoiding trap
- Style: Empowering, humorous, shareable
- Include reference to the specific red flag detected

Make it personal to THIS specific scam attempt.
''';
  }
  
  /// Extract a short scammer quote from the red flag for meme text
  String _extractScammerQuote(String redFlag, String scamType) {
    // Create a concise scammer quote based on the red flag
    if (redFlag.toLowerCase().contains('urgent') || redFlag.toLowerCase().contains('immediately')) {
      return 'Act NOW or lose everything!';
    } else if (redFlag.toLowerCase().contains('money') || redFlag.toLowerCase().contains('payment')) {
      return 'Send money first, questions later!';
    } else if (redFlag.toLowerCase().contains('love') || redFlag.toLowerCase().contains('relationship')) {
      return 'I love you, just need some cash...';
    } else if (redFlag.toLowerCase().contains('prize') || redFlag.toLowerCase().contains('won')) {
      return 'You won! Just pay the fees...';
    } else if (redFlag.toLowerCase().contains('job') || redFlag.toLowerCase().contains('hire')) {
      return 'Great job! Just pay for training...';
    } else if (redFlag.toLowerCase().contains('click') || redFlag.toLowerCase().contains('link')) {
      return 'Click this link immediately!';
    } else if (redFlag.toLowerCase().contains('personal') || redFlag.toLowerCase().contains('information')) {
      return 'We need your password ASAP!';
    } else if (redFlag.toLowerCase().contains('investment') || redFlag.toLowerCase().contains('profit')) {
      return 'Guaranteed 500% returns!';
    } else {
      // Extract first 40 chars of the red flag as quote
      String quote = redFlag.length > 40 ? redFlag.substring(0, 40) + '...' : redFlag;
      return quote;
    }
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
