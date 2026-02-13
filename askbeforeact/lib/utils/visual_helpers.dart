import 'package:flutter/material.dart';

/// Helper class for visual enhancements and emoji support
class VisualHelpers {
  /// Get emoji based on risk score
  static String getRiskEmoji(int score) {
    if (score >= 70) return '🚨';
    if (score >= 40) return '⚠️';
    return '✅';
  }
  
  /// Get emoji based on scam type
  static String getScamEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'phishing':
        return '🎣';
      case 'romance':
        return '💔';
      case 'payment':
        return '💳';
      case 'job':
        return '💼';
      case 'tech_support':
        return '💻';
      case 'investment':
        return '💰';
      case 'lottery':
        return '🎰';
      case 'impersonation':
        return '🎭';
      default:
        return '⚠️';
    }
  }
  
  /// Get color based on risk score
  static Color getRiskColor(int score) {
    if (score >= 70) return const Color(0xFFEF4444); // Red
    if (score >= 40) return const Color(0xFFF59E0B); // Orange
    return const Color(0xFF10B981); // Green
  }
  
  /// Get catchy warning phrase based on scam type
  static String getWarningPhrase(String type) {
    switch (type.toLowerCase()) {
      case 'phishing':
        return "Don't Take the Bait! 🎣";
      case 'romance':
        return "Love Shouldn't Cost Money 💔";
      case 'payment':
        return "Stop! Verify Before You Pay 💳";
      case 'job':
        return "Real Jobs Don't Ask for Money 💼";
      case 'tech_support':
        return "Microsoft Won't Call You! 💻";
      case 'investment':
        return "If It's Too Good to Be True... 💰";
      case 'lottery':
        return "You Can't Win What You Didn't Enter 🎰";
      case 'impersonation':
        return "They're Not Who They Say They Are 🎭";
      default:
        return "Stay Alert! Scam Detected ⚠️";
    }
  }
  
  /// Generate a text-based visual card
  static String generateTextVisual({
    required int riskScore,
    required String riskLevel,
    required String scamType,
    required List<String> redFlags,
    required List<String> recommendations,
  }) {
    final riskEmoji = getRiskEmoji(riskScore);
    final scamEmoji = getScamEmoji(scamType);
    final warningPhrase = getWarningPhrase(scamType);
    
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('$riskEmoji $scamEmoji SCAM ALERT $scamEmoji $riskEmoji');
    buffer.writeln();
    buffer.writeln(warningPhrase);
    buffer.writeln();
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln();
    
    // Risk info
    buffer.writeln('📊 RISK ASSESSMENT');
    buffer.writeln('   Level: ${riskLevel.toUpperCase()}');
    buffer.writeln('   Score: $riskScore/100');
    buffer.writeln('   Type: ${_formatScamType(scamType)}');
    buffer.writeln();
    
    // Red flags
    if (redFlags.isNotEmpty) {
      buffer.writeln('🚩 WARNING SIGNS:');
      for (var flag in redFlags) {
        buffer.writeln('   • $flag');
      }
      buffer.writeln();
    }
    
    // Recommendations
    if (recommendations.isNotEmpty) {
      buffer.writeln('✅ WHAT TO DO:');
      for (var rec in recommendations) {
        buffer.writeln('   • $rec');
      }
      buffer.writeln();
    }
    
    // Footer
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('🛡️ Protected by AskBeforeAct');
    
    return buffer.toString();
  }
  
  /// Format scam type for display
  static String _formatScamType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
  
  /// Get animated gradient colors based on risk
  static List<Color> getRiskGradient(int score) {
    if (score >= 70) {
      return [
        const Color(0xFFEF4444), // Red
        const Color(0xFFDC2626), // Darker red
      ];
    } else if (score >= 40) {
      return [
        const Color(0xFFF59E0B), // Orange
        const Color(0xFFD97706), // Darker orange
      ];
    } else {
      return [
        const Color(0xFF10B981), // Green
        const Color(0xFF059669), // Darker green
      ];
    }
  }
  
  /// Get fun fact or tip based on scam type
  static String getFunFact(String type) {
    switch (type.toLowerCase()) {
      case 'phishing':
        return "💡 Fun Fact: The term 'phishing' comes from 'fishing' - scammers cast out bait hoping someone will bite!";
      case 'romance':
        return "💡 Did You Know: Romance scams cost victims over \$1.3 billion annually. Never send money to someone you haven't met!";
      case 'payment':
        return "💡 Pro Tip: Legitimate companies will never ask you to pay with gift cards or cryptocurrency!";
      case 'job':
        return "💡 Remember: Real employers pay YOU, not the other way around!";
      case 'tech_support':
        return "💡 Fact: Microsoft, Apple, and Google will NEVER call you about computer problems!";
      case 'investment':
        return "💡 Warning: If someone guarantees returns with 'no risk', it's definitely a scam!";
      case 'lottery':
        return "💡 Reality Check: You can't win a lottery you didn't enter. Period.";
      default:
        return "💡 Stay Safe: When in doubt, verify through official channels!";
    }
  }
  
  /// Get shareable message
  static String getShareableMessage({
    required String scamType,
    required int riskScore,
  }) {
    final emoji = getScamEmoji(scamType);
    final phrase = getWarningPhrase(scamType);
    
    return '''
$emoji SCAM ALERT $emoji

$phrase

I just detected a ${_formatScamType(scamType)} scam with a risk score of $riskScore/100 using AskBeforeAct!

🛡️ Stay safe online - always verify suspicious content before taking action.

#StaySafe #ScamAlert #AskBeforeAct
''';
  }
}
