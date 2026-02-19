/// Chat message model for the Learn section chatbot
class ChatMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final String? error;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.error,
  });

  /// Create a user message
  factory ChatMessageModel.user(String content) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  /// Create an AI message
  factory ChatMessageModel.ai(String content, {MessageType? type}) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      type: type ?? MessageType.text,
    );
  }

  /// Create a loading message
  factory ChatMessageModel.loading() {
    return ChatMessageModel(
      id: 'loading',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.loading,
    );
  }

  /// Create an error message
  factory ChatMessageModel.error(String error) {
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Sorry, I encountered an error. Please try again.',
      isUser: false,
      timestamp: DateTime.now(),
      type: MessageType.error,
      error: error,
    );
  }

  /// Get formatted time
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  ChatMessageModel copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
    String? error,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      error: error ?? this.error,
    );
  }
}

/// Message types for different UI rendering
enum MessageType {
  text,
  summary,
  loading,
  error,
}
