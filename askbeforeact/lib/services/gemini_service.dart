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
You are a multilingual fraud detection expert. Analyze the following content for potential fraud indicators.

IMPORTANT MULTILINGUAL INSTRUCTIONS:
1. The content may be in ANY language including English, Chinese (Simplified/Traditional), Malay, or others.
2. DETECT the primary language of the input content.
3. Read and understand the text in its original language.
4. Analyze the fraudulent intent regardless of the language used.
5. CRITICAL: Provide your entire analysis (scamType, redFlags, recommendations) in THE SAME LANGUAGE as the input content.
   - If input is in Chinese, respond in Chinese
   - If input is in Malay, respond in Malay
   - If input is in English, respond in English
   - If input is mixed languages, use the dominant language

Content Type: text
Content: "$text"

Analyze for fraud indicators:
- Urgency tactics and pressure
- Requests for money or personal information
- Suspicious links or contact methods
- Impersonation of legitimate entities
- Too-good-to-be-true offers
- Threats or consequences
- Poor grammar or suspicious phrasing (in any language)
- Romance or emotional manipulation
- Investment or financial schemes

Provide a JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1 in original language", "flag2 in original language", ...],
  "recommendations": ["action1 in original language", "action2 in original language", ...],
  "confidence": "low" | "medium" | "high"
}

REMEMBER: Write scamType description, redFlags, and recommendations in the SAME LANGUAGE as the input content. Be specific and cite evidence. Return ONLY valid JSON without any markdown formatting or code blocks.
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
You are a multilingual fraud detection expert with advanced OCR capabilities. Analyze this screenshot for fraud indicators.

CRITICAL INSTRUCTIONS FOR MULTILINGUAL OCR:
1. FIRST, perform comprehensive OCR to extract ALL text from the image in ANY language.
2. The text may be in English, Chinese (Simplified 简体中文 or Traditional 繁體中文), Malay (Bahasa Melayu), or other languages.
3. Read and recognize Chinese characters (汉字/漢字), English text, Malay text, and mixed-language content.
4. DO NOT skip or ignore text just because it's in a non-English language.
5. Extract ALL visible text including: messages, URLs, buttons, headers, usernames, timestamps, etc.
6. DETECT the primary language of the extracted text.
7. Analyze the fraudulent intent based on the extracted text regardless of the original language.
8. CRITICAL: Provide your entire analysis (scamType description, redFlags, recommendations) in THE SAME LANGUAGE as the text you extracted from the image.
   - If the image contains primarily Chinese text, respond in Chinese
   - If the image contains primarily Malay text, respond in Malay
   - If the image contains primarily English text, respond in English
   - If mixed languages, use the dominant language

Look for fraud indicators:
- Suspicious URLs or domains (in any language)
- Urgency tactics ("Act now!", "立即行动!", "Segera!", "Limited time!", "限时优惠!", etc.)
- Requests for personal information (passwords, SSN, credit cards, bank details, 密码, 银行账户, etc.)
- Impersonation of legitimate companies (banks, government, e-commerce, 银行, 政府, etc.)
- Poor grammar or spelling (in any language)
- Unrealistic promises or offers (get rich quick, 快速致富, lottery wins, 中奖, etc.)
- Payment requests via unusual methods (gift cards, crypto, wire transfer, 礼品卡, 加密货币, etc.)
- Threats or pressure tactics (account suspension, 账户冻结, legal action, 法律诉讼, etc.)
- Too-good-to-be-true offers (free money, 免费金钱, guaranteed returns, 保证回报, etc.)
- Romance or emotional manipulation (love declarations, 爱的宣言, quick relationships, etc.)

IMPORTANT: Extract text FIRST via OCR, detect its language, then provide your analysis in THAT SAME LANGUAGE.

Provide JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1 in original language", "flag2 in original language", ...],
  "recommendations": ["action1 in original language", "action2 in original language", ...],
  "confidence": "low" | "medium" | "high"
}

REMEMBER: Write redFlags and recommendations in the SAME LANGUAGE as the text extracted from the image. Be specific and cite actual text you see. Return ONLY valid JSON without any markdown formatting or code blocks.
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
You are a multilingual fraud detection expert. Analyze this URL for safety: $url

MULTILINGUAL AWARENESS:
- The URL may contain internationalized domain names (IDN) or Unicode characters
- Check for homograph attacks using characters from different scripts (e.g., Cyrillic, Greek, Chinese)
- Be aware of domains targeting Chinese, Malay, or other language speakers
- Recognize localized versions of scams (e.g., 淘宝.com vs taobao.com)

Check for:
- Domain reputation and legitimacy
- HTTPS presence
- Suspicious patterns (typosquatting, homograph attacks, IDN spoofing)
- Known phishing indicators
- Unusual TLDs or subdomains
- URL shorteners masking destination
- Misspellings of popular brands (in any language/script)
- Suspicious parameters or query strings
- Internationalized domain name (IDN) abuse
- Mixed-script attacks (e.g., using Cyrillic 'а' instead of Latin 'a')

Provide JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "investment" | "lottery" | "impersonation" | "other",
  "redFlags": ["flag1", "flag2", ...],
  "recommendations": ["action1", "action2", ...],
  "confidence": "low" | "medium" | "high"
}

Be specific about URL characteristics. Mention if Unicode/IDN characters are used. Return ONLY valid JSON without any markdown formatting or code blocks.
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
