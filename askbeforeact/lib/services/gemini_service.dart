import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import '../core/config/env_config.dart';
import '../models/analysis_model.dart';

/// Service for Gemini AI fraud detection
class GeminiService {
  late final GenerativeModel _textModel;
  
  GeminiService() {
    // Use Gemini 2.5 Flash - Latest free tier model with multimodal support
    // Available models from your API: gemini-2.5-flash, gemini-flash-latest
    _textModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4, // Lower = more consistent
        topK: 32,
        topP: 1,
        maxOutputTokens: 2048,
      ),
    );
  }
  
  /// List available models for debugging
  Future<List<String>> listAvailableModels() async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=${EnvConfig.geminiApiKey}'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = (data['models'] as List)
            .map((model) => model['name'] as String)
            .where((name) => name.contains('gemini'))
            .toList();
        
        print('Available models: $models');
        return models;
      } else {
        print('Failed to list models: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error listing models: $e');
      return [];
    }
  }

  /// Analyze text content for fraud indicators
  Future<Map<String, dynamic>> analyzeText(String text) async {
    try {
      final prompt = '''
You are a fraud detection expert. Analyze the following content for potential fraud indicators.

Content Type: text
Content: "$text"

Provide a JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1", "flag2", ...],
  "recommendations": ["action1", "action2", ...],
  "confidence": "low" | "medium" | "high"
}

Be specific and cite evidence from the content. Return ONLY valid JSON without any markdown formatting or code blocks.
''';

      final response = await _textModel.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean the response text (remove markdown code blocks if present)
      String cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      } else if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      final jsonResponse = jsonDecode(cleanedText);
      return _validateAndNormalizeResponse(jsonResponse);
    } catch (e) {
      throw Exception('Failed to analyze text: $e');
    }
  }

  /// Analyze image/screenshot for fraud indicators
  Future<Map<String, dynamic>> analyzeImage(Uint8List imageBytes) async {
    try {
      final prompt = '''
Analyze this screenshot for fraud indicators. Look for:
- Suspicious URLs or domains
- Urgency tactics ("Act now!", "Limited time!", etc.)
- Requests for personal information (passwords, SSN, credit cards)
- Impersonation of legitimate companies
- Poor grammar or spelling
- Unrealistic promises or offers
- Payment requests via unusual methods
- Threats or pressure tactics
- Too-good-to-be-true offers

Provide JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1", "flag2", ...],
  "recommendations": ["action1", "action2", ...],
  "confidence": "low" | "medium" | "high"
}

Be specific about what you see in the image. Return ONLY valid JSON without any markdown formatting or code blocks.
''';

      // Use text model for image analysis (Gemini 1.5 Flash supports multimodal)
      final response = await _textModel.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      final responseText = response.text;
      
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean the response text
      String cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      } else if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      final jsonResponse = jsonDecode(cleanedText);
      return _validateAndNormalizeResponse(jsonResponse);
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }

  /// Analyze URL for safety
  Future<Map<String, dynamic>> analyzeUrl(String url) async {
    try {
      final prompt = '''
Analyze this URL for safety: $url

Check for:
- Domain reputation and legitimacy
- HTTPS presence
- Suspicious patterns (typosquatting, homograph attacks, etc.)
- Known phishing indicators
- Unusual TLDs or subdomains
- URL shorteners masking destination
- Misspellings of popular brands
- Suspicious parameters or query strings

Provide JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1", "flag2", ...],
  "recommendations": ["action1", "action2", ...],
  "confidence": "low" | "medium" | "high"
}

Be specific about URL characteristics. Return ONLY valid JSON without any markdown formatting or code blocks.
''';

      final response = await _textModel.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean the response text
      String cleanedText = responseText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      } else if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      final jsonResponse = jsonDecode(cleanedText);
      return _validateAndNormalizeResponse(jsonResponse);
    } catch (e) {
      throw Exception('Failed to analyze URL: $e');
    }
  }

  /// Validate and normalize the API response
  Map<String, dynamic> _validateAndNormalizeResponse(Map<String, dynamic> response) {
    // Ensure all required fields exist with proper types
    final riskScore = (response['riskScore'] as num?)?.toInt() ?? 50;
    final riskLevel = response['riskLevel'] as String? ?? 'medium';
    final scamType = response['scamType'] as String? ?? 'other';
    final confidence = response['confidence'] as String? ?? 'medium';
    
    // Ensure arrays are properly formatted
    final redFlags = (response['redFlags'] as List?)
        ?.map((e) => e.toString())
        .toList() ?? ['Unable to determine specific red flags'];
    
    final recommendations = (response['recommendations'] as List?)
        ?.map((e) => e.toString())
        .toList() ?? ['Exercise caution and verify the source'];

    // Validate risk score range
    final validatedRiskScore = riskScore.clamp(0, 100);

    // Validate risk level
    final validRiskLevel = ['low', 'medium', 'high'].contains(riskLevel.toLowerCase())
        ? riskLevel.toLowerCase()
        : 'medium';

    // Validate confidence
    final validConfidence = ['low', 'medium', 'high'].contains(confidence.toLowerCase())
        ? confidence.toLowerCase()
        : 'medium';

    return {
      'riskScore': validatedRiskScore,
      'riskLevel': validRiskLevel,
      'scamType': scamType,
      'redFlags': redFlags,
      'recommendations': recommendations,
      'confidence': validConfidence,
    };
  }

  /// Create AnalysisModel from Gemini response
  AnalysisModel createAnalysisModel({
    required String userId,
    required String type,
    required String content,
    required Map<String, dynamic> geminiResponse,
  }) {
    return AnalysisModel(
      id: '', // Will be set by Firestore
      userId: userId,
      type: type,
      content: content,
      riskScore: geminiResponse['riskScore'] as int,
      riskLevel: geminiResponse['riskLevel'] as String,
      scamType: geminiResponse['scamType'] as String,
      redFlags: List<String>.from(geminiResponse['redFlags']),
      recommendations: List<String>.from(geminiResponse['recommendations']),
      confidence: geminiResponse['confidence'] as String,
      createdAt: DateTime.now(),
    );
  }
}
