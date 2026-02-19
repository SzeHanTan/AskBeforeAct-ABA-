import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

// Services
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'services/gemini_service.dart';
import 'services/podcast_service.dart';
import 'services/education_service.dart';
import 'services/chatbot_service.dart';

// Repositories
import 'repositories/user_repository.dart';
import 'repositories/analysis_repository.dart';
import 'repositories/community_repository.dart';
import 'repositories/education_repository.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/analysis_provider.dart';
import 'providers/community_provider.dart';
import 'providers/education_provider.dart';
import 'providers/chatbot_provider.dart';

// Screens
import 'views/home/landing_screen.dart';
import 'views/analysis/analyze_screen.dart';
import 'views/education/education_screen.dart';
import 'views/community/community_screen.dart';
import 'views/home/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const AskBeforeActApp());
}

class AskBeforeActApp extends StatelessWidget {
  const AskBeforeActApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final storageService = StorageService();
    final geminiService = GeminiService();
    final podcastService = PodcastService();

    // Initialize repositories
    final userRepository = UserRepository(
      authService: authService,
      firestoreService: firestoreService,
      storageService: storageService,
    );

    final analysisRepository = AnalysisRepository(
      geminiService: geminiService,
      firestoreService: firestoreService,
      storageService: storageService,
    );

    final communityRepository = CommunityRepository(
      firestoreService: firestoreService,
      podcastService: podcastService,
    );

    final educationRepository = EducationRepository();
    final educationService = EducationService(repository: educationRepository);
    final chatbotService = ChatbotService();

    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(userRepository: userRepository),
        ),
        // Analysis Provider
        ChangeNotifierProvider(
          create: (_) => AnalysisProvider(analysisRepository: analysisRepository),
        ),
        // Community Provider
        ChangeNotifierProvider(
          create: (_) => CommunityProvider(communityRepository: communityRepository),
        ),
        // Education Provider
        ChangeNotifierProvider(
          create: (_) => EducationProvider(educationService: educationService),
        ),
        // Chatbot Provider
        ChangeNotifierProvider(
          create: (_) => ChatbotProvider(chatbotService: chatbotService),
        ),
      ],
      child: MaterialApp(
        title: 'AskBeforeAct - AI Fraud Detection',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        routes: {
          '/analyze': (context) => const AnalyzeScreen(),
          '/education': (context) => const EducationScreen(),
          '/community': (context) => const CommunityScreen(),
          '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}

/// Wrapper to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while initializing
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Show landing screen (handles both authenticated and unauthenticated states)
        return const LandingScreen();
      },
    );
  }
}
