import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/config/env_config.dart';
import '../models/scam_news_model.dart';
import '../models/education_content_model.dart';

/// Service for Learn section AI chatbot using Gemini
class ChatbotService {
  late final GenerativeModel _chatModel;
  ChatSession? _chatSession;

  ChatbotService() {
    _chatModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048,
      ),
      systemInstruction: Content.system(_getSystemPrompt()),
    );
  }

  /// Initialize chat session with context
  void initializeChatSession({
    List<EducationContentModel>? educationContent,
    List<ScamNewsModel>? scamNews,
  }) {
    final contextParts = <String>[];

    if (educationContent != null && educationContent.isNotEmpty) {
      contextParts.add(_buildEducationContext(educationContent));
    }

    if (scamNews != null && scamNews.isNotEmpty) {
      contextParts.add(_buildNewsContext(scamNews));
    }

    final initialContext = contextParts.join('\n\n');

    _chatSession = _chatModel.startChat(
      history: [
        Content.text(initialContext),
        Content.model([TextPart('I understand. I\'m ready to help you learn about scams and fraud. I have access to education content about common scam types and the latest scam news. How can I assist you today?')]),
      ],
    );
  }

  /// Send message and get response
  Future<String> sendMessage(String message) async {
    try {
      if (_chatSession == null) {
        initializeChatSession();
      }

      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );

      return response.text ?? 'I apologize, but I couldn\'t generate a response. Please try again.';
    } catch (e) {
      print('Error in chatbot: $e');
      throw Exception('Failed to get response: $e');
    }
  }

  /// Summarize news articles
  Future<String> summarizeNews(List<ScamNewsModel> news) async {
    try {
      if (news.isEmpty) {
        return 'No news articles available to summarize.';
      }

      final newsContext = _buildNewsContext(news);
      
      final prompt = '''
Based on the following scam news articles, provide a comprehensive summary:

$newsContext

Please provide a well-structured summary with these sections:

**Key Trends and Patterns:**
List 3-4 major trends you observe in the news

**Most Common Scam Types:**
List the scam types mentioned with approximate percentages if possible

**Geographic Regions Affected:**
Mention which regions or countries are affected

**Critical Warnings:**
List 3-4 important warnings for users (use ⚠️ emoji)

**Actionable Advice:**
Provide 5 specific, actionable steps users should take

Format your response using markdown:
- Use **bold** for emphasis
- Use bullet points (•) for lists
- Use numbered lists for steps
- Use emojis where appropriate (⚠️ 🚨 ✅ ❌ 💡)
- Keep it concise but comprehensive (250-350 words)
- Make it easy to scan and read

Start with a brief intro sentence, then provide the sections above.
''';

      final response = await _chatModel.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? 'Unable to generate summary.';
    } catch (e) {
      print('Error summarizing news: $e');
      throw Exception('Failed to summarize news: $e');
    }
  }

  /// Get quick tips about a specific scam type
  Future<String> getScamTypeTips(String scamType) async {
    try {
      final prompt = '''
Provide 5 quick, actionable tips to protect yourself from $scamType scams.
Make them practical and easy to remember.
Format as a numbered list.
''';

      final response = await _chatModel.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? 'Unable to generate tips.';
    } catch (e) {
      print('Error getting tips: $e');
      throw Exception('Failed to get tips: $e');
    }
  }

  /// Analyze if a scenario is a scam
  Future<String> analyzeScenario(String scenario) async {
    try {
      final prompt = '''
A user is describing a potential scam scenario:

"$scenario"

Please analyze this and provide:
1. Is this likely a scam? (Yes/No/Maybe)
2. What type of scam is this?
3. Red flags in this scenario
4. What the user should do next
5. How to verify if it's legitimate

Be direct and helpful. Use clear language.
''';

      final response = await _chatModel.generateContent([
        Content.text(prompt),
      ]);

      return response.text ?? 'Unable to analyze scenario.';
    } catch (e) {
      print('Error analyzing scenario: $e');
      throw Exception('Failed to analyze scenario: $e');
    }
  }

  /// Get suggested questions for the user
  List<String> getSuggestedQuestions() {
    return [
      'Summarize the latest scam news',
      'How can I identify phishing emails?',
      'What are the warning signs of romance scams?',
      'How do I protect myself from payment fraud?',
      'What should I do if I think I\'ve been scammed?',
      'Tell me about the latest scam trends',
    ];
  }

  /// Reset chat session
  void resetChat({
    List<EducationContentModel>? educationContent,
    List<ScamNewsModel>? scamNews,
  }) {
    initializeChatSession(
      educationContent: educationContent,
      scamNews: scamNews,
    );
  }

  /// Build system prompt for the chatbot
  String _getSystemPrompt() {
    return '''
You are a helpful AI assistant specializing in fraud prevention and scam education. Your role is to:

1. Help users understand different types of scams and fraud
2. Provide clear, actionable advice on how to protect themselves
3. Answer questions about scam warning signs and prevention tips
4. Summarize recent scam news and trends
5. Analyze scenarios to help users identify potential scams

Guidelines:
- Be friendly, clear, and concise
- Use simple language that everyone can understand
- Provide specific, actionable advice
- Be empathetic when users share their concerns
- Focus on education and prevention
- If asked about specific news, reference the articles provided in context
- If you don't have enough information, be honest about it
- Never provide legal or financial advice
- Always encourage users to report scams to authorities

Formatting Guidelines (IMPORTANT):
- Use **bold** for emphasis and important terms
- Use bullet points (•) or numbered lists for clarity
- Use emojis appropriately (⚠️ for warnings, ✅ for good actions, ❌ for bad actions, 🚨 for urgent alerts)
- Structure responses with clear sections
- Use line breaks between sections for readability
- Keep paragraphs short (2-3 sentences max)
- Use markdown formatting that will render properly

You have access to:
- Education content about common scam types
- Latest scam news articles from Google News
- General knowledge about fraud prevention

When summarizing news, focus on:
- Key trends and patterns
- Most common scam types
- Geographic regions affected
- Important warnings
- Actionable advice

Keep responses conversational, well-formatted, and helpful.
''';
  }

  /// Build education content context
  String _buildEducationContext(List<EducationContentModel> content) {
    final buffer = StringBuffer();
    buffer.writeln('=== EDUCATION CONTENT ===');
    buffer.writeln('Common scam types and prevention information:');
    buffer.writeln();

    for (final item in content) {
      buffer.writeln('## ${item.title}');
      buffer.writeln('Description: ${item.description}');
      buffer.writeln();
      
      buffer.writeln('Warning Signs:');
      for (final sign in item.warningSigns) {
        buffer.writeln('- $sign');
      }
      buffer.writeln();
      
      buffer.writeln('Prevention Tips:');
      for (final tip in item.preventionTips) {
        buffer.writeln('- $tip');
      }
      buffer.writeln();
      
      buffer.writeln('Example: ${item.example}');
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Build news context
  String _buildNewsContext(List<ScamNewsModel> news) {
    final buffer = StringBuffer();
    buffer.writeln('=== LATEST SCAM NEWS ===');
    buffer.writeln('Recent scam and fraud news articles:');
    buffer.writeln();

    final recentNews = news.take(10).toList();

    for (var i = 0; i < recentNews.length; i++) {
      final article = recentNews[i];
      buffer.writeln('Article ${i + 1}:');
      buffer.writeln('Title: ${article.title}');
      buffer.writeln('Source: ${article.source}');
      buffer.writeln('Date: ${article.formattedDate}');
      buffer.writeln('Summary: ${article.contentSnippet}');
      buffer.writeln('Link: ${article.link}');
      buffer.writeln();
    }

    return buffer.toString();
  }
}
