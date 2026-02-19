import '../models/education_content_model.dart';
import '../models/scam_news_model.dart';
import '../repositories/education_repository.dart';

/// Service for education content and scam news
class EducationService {
  final EducationRepository _repository;

  EducationService({EducationRepository? repository})
      : _repository = repository ?? EducationRepository();

  /// Get all education content
  Stream<List<EducationContentModel>> getEducationContent() {
    return _repository.getEducationContent();
  }

  /// Get education content by ID
  Future<EducationContentModel?> getEducationContentById(String id) {
    return _repository.getEducationContentById(id);
  }

  /// Get scam news articles
  Stream<List<ScamNewsModel>> getScamNews({int limit = 20}) {
    return _repository.getScamNews(limit: limit);
  }

  /// Get recent scam news (last 24 hours)
  Stream<List<ScamNewsModel>> getRecentScamNews() {
    return _repository.getRecentScamNews();
  }

  /// Search scam news
  Future<List<ScamNewsModel>> searchScamNews(String query) {
    return _repository.searchScamNews(query);
  }

  /// Get scam news count
  Future<int> getScamNewsCount() {
    return _repository.getScamNewsCount();
  }

  /// Get education content with fallback data
  /// Returns hardcoded data if Firebase is not available
  Future<List<EducationContentModel>> getEducationContentWithFallback() async {
    try {
      final content = await _repository
          .getEducationContent()
          .first
          .timeout(const Duration(seconds: 5));
      
      if (content.isNotEmpty) {
        return content;
      }
      
      return _getFallbackEducationContent();
    } catch (e) {
      print('Error fetching education content, using fallback: $e');
      return _getFallbackEducationContent();
    }
  }

  /// Fallback education content if Firebase is unavailable
  List<EducationContentModel> _getFallbackEducationContent() {
    return [
      EducationContentModel(
        id: 'phishing',
        title: 'Phishing Emails',
        description: 'Fake emails pretending to be from legitimate companies',
        warningSigns: [
          'Urgent requests for personal information',
          'Suspicious sender email addresses',
          'Poor grammar and spelling mistakes',
          'Requests to click suspicious links',
          'Threats of account closure'
        ],
        preventionTips: [
          'Verify sender email addresses carefully',
          'Never click suspicious links',
          'Contact companies directly through official channels',
          'Enable two-factor authentication',
          'Use email filters and spam detection'
        ],
        example: 'An email claiming to be from your bank asking you to "verify your account" by clicking a link and entering your password.',
        order: 1,
      ),
      EducationContentModel(
        id: 'romance',
        title: 'Romance Scams',
        description: 'Fake online relationships designed to steal money',
        warningSigns: [
          'Quick declarations of love',
          'Reluctance to meet in person or video call',
          'Requests for money or financial help',
          'Stories of emergencies or crises',
          'Inconsistent personal details'
        ],
        preventionTips: [
          'Be cautious with online relationships',
          'Never send money to someone you haven\'t met',
          'Do reverse image searches on profile photos',
          'Take relationships slowly',
          'Trust your instincts if something feels wrong'
        ],
        example: 'Someone you met online professes love quickly, then asks for money to help with a medical emergency or travel costs to visit you.',
        order: 2,
      ),
      EducationContentModel(
        id: 'payment',
        title: 'Payment Fraud',
        description: 'Unauthorized charges and fake payment requests',
        warningSigns: [
          'Unexpected payment requests',
          'Unfamiliar charges on statements',
          'Requests for unusual payment methods',
          'Pressure to pay immediately',
          'Requests to pay via gift cards or cryptocurrency'
        ],
        preventionTips: [
          'Monitor your accounts regularly',
          'Use secure payment methods',
          'Verify payment requests independently',
          'Set up transaction alerts',
          'Never pay with gift cards for legitimate services'
        ],
        example: 'Receiving a call claiming you owe taxes and must pay immediately with gift cards or face arrest.',
        order: 3,
      ),
      EducationContentModel(
        id: 'job',
        title: 'Job Scams',
        description: 'Fake job offers and work-from-home schemes',
        warningSigns: [
          'Jobs requiring upfront payment',
          'Unrealistic salary promises',
          'Vague job descriptions',
          'Requests for personal financial information early',
          'Pressure to start immediately without proper interview'
        ],
        preventionTips: [
          'Research companies thoroughly',
          'Never pay for job opportunities',
          'Be wary of too-good-to-be-true offers',
          'Verify job postings on official company websites',
          'Use reputable job platforms'
        ],
        example: 'A "work from home" opportunity promising \$5000/week but requiring you to pay for training materials or equipment upfront.',
        order: 4,
      ),
      EducationContentModel(
        id: 'tech_support',
        title: 'Tech Support Scams',
        description: 'Fake technical support claiming to fix your device',
        warningSigns: [
          'Unsolicited calls about computer problems',
          'Pop-ups claiming your device is infected',
          'Requests for remote access to your device',
          'Pressure to pay for unnecessary services',
          'Claims to be from Microsoft, Apple, or other tech companies'
        ],
        preventionTips: [
          'Legitimate companies don\'t call unsolicited',
          'Never give remote access to strangers',
          'Use official support channels only',
          'Install reputable antivirus software',
          'Hang up on suspicious tech support calls'
        ],
        example: 'A pop-up warning that your computer is infected, with a phone number to call for "immediate support" that charges hundreds of dollars.',
        order: 5,
      ),
    ];
  }
}
