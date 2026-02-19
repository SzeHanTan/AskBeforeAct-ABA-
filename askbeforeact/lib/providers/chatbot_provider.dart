import 'package:flutter/foundation.dart';
import '../models/chat_message_model.dart';
import '../models/scam_news_model.dart';
import '../models/education_content_model.dart';
import '../services/chatbot_service.dart';

/// Provider for Learn section chatbot
class ChatbotProvider with ChangeNotifier {
  final ChatbotService _chatbotService;

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  ChatbotProvider({ChatbotService? chatbotService})
      : _chatbotService = chatbotService ?? ChatbotService() {
    _initializeChat();
  }

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Initialize chat with welcome message
  void _initializeChat() {
    _messages = [
      ChatMessageModel.ai(
        '👋 Hello! I\'m your AI assistant for fraud prevention. I can help you:\n\n'
        '• Understand different types of scams\n'
        '• Summarize the latest scam news\n'
        '• Answer questions about fraud prevention\n'
        '• Analyze scenarios to identify potential scams\n\n'
        'What would you like to know?',
      ),
    ];
    _isInitialized = true;
    notifyListeners();
  }

  /// Initialize chatbot with context
  void initializeWithContext({
    List<EducationContentModel>? educationContent,
    List<ScamNewsModel>? scamNews,
  }) {
    _chatbotService.initializeChatSession(
      educationContent: educationContent,
      scamNews: scamNews,
    );
    _isInitialized = true;
    notifyListeners();
  }

  /// Send user message and get AI response
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessageModel.user(content);
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    final loadingMessage = ChatMessageModel.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    try {
      final response = await _chatbotService.sendMessage(content);
      
      _messages.removeLast();
      
      final aiMessage = ChatMessageModel.ai(response);
      _messages.add(aiMessage);
    } catch (e) {
      _messages.removeLast();
      
      final errorMessage = ChatMessageModel.error(e.toString());
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Summarize news articles
  Future<void> summarizeNews(List<ScamNewsModel> news) async {
    if (news.isEmpty) {
      final message = ChatMessageModel.ai(
        'There are no news articles available to summarize at the moment.',
      );
      _messages.add(message);
      notifyListeners();
      return;
    }

    final userMessage = ChatMessageModel.user('Summarize the latest scam news');
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    final loadingMessage = ChatMessageModel.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    try {
      final summary = await _chatbotService.summarizeNews(news);
      
      _messages.removeLast();
      
      final aiMessage = ChatMessageModel.ai(
        summary,
        type: MessageType.summary,
      );
      _messages.add(aiMessage);
    } catch (e) {
      _messages.removeLast();
      
      final errorMessage = ChatMessageModel.error(e.toString());
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get tips for a specific scam type
  Future<void> getScamTypeTips(String scamType) async {
    final userMessage = ChatMessageModel.user('Give me tips about $scamType');
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    final loadingMessage = ChatMessageModel.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    try {
      final tips = await _chatbotService.getScamTypeTips(scamType);
      
      _messages.removeLast();
      
      final aiMessage = ChatMessageModel.ai(tips);
      _messages.add(aiMessage);
    } catch (e) {
      _messages.removeLast();
      
      final errorMessage = ChatMessageModel.error(e.toString());
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Analyze a scenario
  Future<void> analyzeScenario(String scenario) async {
    final userMessage = ChatMessageModel.user('Is this a scam? $scenario');
    _messages.add(userMessage);
    notifyListeners();

    _isLoading = true;
    final loadingMessage = ChatMessageModel.loading();
    _messages.add(loadingMessage);
    notifyListeners();

    try {
      final analysis = await _chatbotService.analyzeScenario(scenario);
      
      _messages.removeLast();
      
      final aiMessage = ChatMessageModel.ai(analysis);
      _messages.add(aiMessage);
    } catch (e) {
      _messages.removeLast();
      
      final errorMessage = ChatMessageModel.error(e.toString());
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get suggested questions
  List<String> getSuggestedQuestions() {
    return _chatbotService.getSuggestedQuestions();
  }

  /// Clear chat history
  void clearChat({
    List<EducationContentModel>? educationContent,
    List<ScamNewsModel>? scamNews,
  }) {
    _messages.clear();
    _chatbotService.resetChat(
      educationContent: educationContent,
      scamNews: scamNews,
    );
    _initializeChat();
  }

  /// Delete a specific message
  void deleteMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }
}
