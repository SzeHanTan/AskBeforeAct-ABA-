# AskBeforeAct (ABA) - Frontend Guidelines
## Flutter Web Development Best Practices

**Version:** 1.0  
**Last Updated:** February 13, 2026  

---

## Table of Contents

1. [Project Architecture](#1-project-architecture)
2. [Code Organization](#2-code-organization)
3. [State Management](#3-state-management)
4. [UI/UX Guidelines](#4-uiux-guidelines)
5. [Naming Conventions](#5-naming-conventions)
6. [Widget Development](#6-widget-development)
7. [Performance Optimization](#7-performance-optimization)
8. [Error Handling](#8-error-handling)
9. [Testing Guidelines](#9-testing-guidelines)
10. [Code Style](#10-code-style)

---

## 1. Project Architecture

### 1.1 Architecture Pattern: MVVM

```
┌─────────────────────────────────────┐
│            View (UI)                │
│  Widgets, Screens, Components       │
└─────────────────────────────────────┘
                ↕
┌─────────────────────────────────────┐
│         ViewModel (Logic)           │
│  ChangeNotifier, Business Logic     │
└─────────────────────────────────────┘
                ↕
┌─────────────────────────────────────┐
│          Model (Data)               │
│  Data Classes, Repositories         │
└─────────────────────────────────────┘
```

**Benefits:**
- Clear separation of concerns
- Testable business logic
- Reusable components
- Easy to maintain and scale

### 1.2 Layer Responsibilities

**View Layer (UI):**
- Display data from ViewModel
- Handle user interactions
- Minimal logic (only UI-related)
- Use StatelessWidget when possible

**ViewModel Layer:**
- Business logic
- State management with Provider
- API calls coordination
- Data transformation

**Model Layer:**
- Data structures
- Repository pattern for data access
- Service classes for external APIs

---

## 2. Code Organization

### 2.1 Folder Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Root app widget
├── firebase_options.dart        # Firebase config
│
├── core/                        # Core utilities
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── helpers.dart
│   └── config/
│       └── env_config.dart
│
├── models/                      # Data models
│   ├── user_model.dart
│   ├── analysis_model.dart
│   ├── community_post_model.dart
│   └── education_content_model.dart
│
├── services/                    # External services
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   ├── ai_service.dart
│   └── analytics_service.dart
│
├── repositories/                # Data layer
│   ├── user_repository.dart
│   ├── analysis_repository.dart
│   └── community_repository.dart
│
├── viewmodels/                  # Business logic
│   ├── auth_viewmodel.dart
│   ├── analysis_viewmodel.dart
│   ├── history_viewmodel.dart
│   └── community_viewmodel.dart
│
├── views/                       # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── reset_password_screen.dart
│   ├── home/
│   │   ├── landing_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── onboarding_screen.dart
│   ├── analysis/
│   │   ├── analyze_screen.dart
│   │   ├── results_screen.dart
│   │   └── history_screen.dart
│   ├── community/
│   │   ├── community_screen.dart
│   │   └── create_post_modal.dart
│   ├── education/
│   │   ├── education_screen.dart
│   │   └── education_detail_screen.dart
│   └── profile/
│       └── profile_screen.dart
│
└── widgets/                     # Reusable widgets
    ├── common/
    │   ├── custom_button.dart
    │   ├── custom_text_field.dart
    │   ├── loading_indicator.dart
    │   └── error_widget.dart
    ├── analysis/
    │   ├── risk_score_widget.dart
    │   ├── red_flags_list.dart
    │   └── recommendations_list.dart
    └── community/
        ├── post_card.dart
        └── vote_buttons.dart
```

### 2.2 Import Order

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// 4. Project imports (alphabetical)
import 'package:askbeforeact/models/user_model.dart';
import 'package:askbeforeact/services/auth_service.dart';
```

---

## 3. State Management

### 3.1 Using Provider

**ChangeNotifier ViewModel Example:**

```dart
import 'package:flutter/foundation.dart';

class AnalysisViewModel extends ChangeNotifier {
  final AnalysisRepository _repository;
  
  // State variables
  bool _isLoading = false;
  String? _error;
  AnalysisModel? _currentAnalysis;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  AnalysisModel? get currentAnalysis => _currentAnalysis;
  
  AnalysisViewModel(this._repository);
  
  // Methods
  Future<void> analyzeContent(String content, String type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentAnalysis = await _repository.analyzeContent(content, type);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

**Providing ViewModel:**

```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(AuthService()),
    ),
    ChangeNotifierProvider(
      create: (_) => AnalysisViewModel(AnalysisRepository()),
    ),
  ],
  child: MyApp(),
)
```

**Consuming ViewModel:**

```dart
// Option 1: Consumer (rebuilds only this widget)
Consumer<AnalysisViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return LoadingIndicator();
    }
    return Text(viewModel.currentAnalysis?.riskScore.toString() ?? '');
  },
)

// Option 2: Provider.of (use when not rebuilding)
final viewModel = Provider.of<AnalysisViewModel>(context, listen: false);
viewModel.analyzeContent(content, type);

// Option 3: context.watch (rebuilds on change)
final viewModel = context.watch<AnalysisViewModel>();

// Option 4: context.read (doesn't rebuild)
context.read<AnalysisViewModel>().analyzeContent(content, type);
```

### 3.2 State Management Best Practices

**DO:**
- ✅ Use `ChangeNotifier` for simple state
- ✅ Call `notifyListeners()` after state changes
- ✅ Use `Consumer` for specific widget rebuilds
- ✅ Use `context.read` for one-time actions
- ✅ Dispose resources in ViewModel

**DON'T:**
- ❌ Call `notifyListeners()` in getters
- ❌ Use `context.watch` in event handlers
- ❌ Store UI state in ViewModel (use local state)
- ❌ Create multiple ViewModels for same data

---

## 4. UI/UX Guidelines

### 4.1 Design System

**Color Palette:**

```dart
// lib/core/constants/app_colors.dart
class AppColors {
  // Primary colors
  static const primary = Color(0xFF2563EB);      // Blue
  static const primaryDark = Color(0xFF1E40AF);
  static const primaryLight = Color(0xFF60A5FA);
  
  // Risk levels
  static const riskLow = Color(0xFF10B981);      // Green
  static const riskMedium = Color(0xFFF59E0B);   // Yellow
  static const riskHigh = Color(0xFFEF4444);     // Red
  
  // Neutral colors
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  
  // Semantic colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
}
```

**Typography:**

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
```

**Spacing System:**

```dart
// lib/core/constants/app_spacing.dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### 4.2 Responsive Design

**Breakpoints:**

```dart
// lib/core/utils/responsive.dart
class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 640;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 640 && width < 1024;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }
  
  static double value(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }
}
```

**Usage:**

```dart
Container(
  width: Responsive.value(
    context,
    mobile: 100,
    tablet: 150,
    desktop: 200,
  ),
)
```

### 4.3 Accessibility

**DO:**
- ✅ Use `Semantics` widget for screen readers
- ✅ Provide text alternatives for images
- ✅ Ensure minimum contrast ratio (4.5:1)
- ✅ Support keyboard navigation
- ✅ Use semantic HTML in web builds

**Example:**

```dart
Semantics(
  label: 'Risk score: ${analysis.riskScore}%',
  child: RiskScoreWidget(score: analysis.riskScore),
)
```

---

## 5. Naming Conventions

### 5.1 File Names

- Use **snake_case**: `analysis_screen.dart`
- Be descriptive: `create_post_modal.dart` not `modal.dart`
- Suffix with type: `_screen`, `_widget`, `_model`, `_service`

### 5.2 Class Names

- Use **PascalCase**: `AnalysisScreen`, `UserModel`
- Suffix widgets with `Widget`: `RiskScoreWidget`
- Suffix screens with `Screen`: `DashboardScreen`

### 5.3 Variable Names

- Use **camelCase**: `riskScore`, `currentUser`
- Private variables start with `_`: `_isLoading`
- Boolean variables start with `is`, `has`, `should`: `isLoading`, `hasError`

### 5.4 Method Names

- Use **camelCase**: `analyzeContent()`, `getUserData()`
- Start with verb: `fetchAnalyses()`, `updateProfile()`
- Async methods should indicate action: `loadUserData()` not `userDataLoader()`

### 5.5 Constants

- Use **lowerCamelCase**: `maxFileSize`, `apiTimeout`
- For compile-time constants: `static const maxFileSize = 5 * 1024 * 1024;`

---

## 6. Widget Development

### 6.1 Widget Types

**StatelessWidget (Preferred):**

```dart
class RiskScoreWidget extends StatelessWidget {
  final int riskScore;
  
  const RiskScoreWidget({
    Key? key,
    required this.riskScore,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget tree
    );
  }
}
```

**StatefulWidget (When needed):**

```dart
class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({Key? key}) : super(key: key);
  
  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final _textController = TextEditingController();
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget tree
    );
  }
}
```

### 6.2 Widget Composition

**DO: Break into smaller widgets**

```dart
// Good
class AnalysisCard extends StatelessWidget {
  final AnalysisModel analysis;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(),
          _buildRiskScore(),
          _buildRedFlags(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() => /* ... */;
  Widget _buildRiskScore() => /* ... */;
  Widget _buildRedFlags() => /* ... */;
}
```

**DON'T: Create deeply nested trees**

```dart
// Bad
Widget build(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                child: Text(/* ... */),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

### 6.3 Reusable Widgets

**Custom Button:**

```dart
// lib/widgets/common/custom_button.dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(text),
    );
  }
}
```

**Custom Text Field:**

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  
  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
```

---

## 7. Performance Optimization

### 7.1 Build Optimization

**DO:**
- ✅ Use `const` constructors whenever possible
- ✅ Extract widgets to reduce rebuilds
- ✅ Use `ListView.builder` for long lists
- ✅ Implement `shouldRebuild` in custom widgets

**Example:**

```dart
// Good: const constructor
const Text('Hello', style: TextStyle(fontSize: 16))

// Good: ListView.builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 7.2 Image Optimization

```dart
// Use CachedNetworkImage for remote images
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)

// Compress images before upload
import 'package:image/image.dart' as img;

Future<Uint8List> compressImage(Uint8List bytes) async {
  final image = img.decodeImage(bytes);
  final compressed = img.encodeJpg(image!, quality: 85);
  return Uint8List.fromList(compressed);
}
```

### 7.3 Lazy Loading

```dart
// Load data on demand
class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data
      context.read<HistoryViewModel>().loadMore();
    }
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

## 8. Error Handling

### 8.1 Try-Catch Blocks

```dart
Future<void> analyzeContent(String content) async {
  try {
    _isLoading = true;
    notifyListeners();
    
    final result = await _aiService.analyze(content);
    _currentAnalysis = result;
    
  } on FirebaseException catch (e) {
    _error = 'Firebase error: ${e.message}';
  } on NetworkException catch (e) {
    _error = 'Network error: ${e.message}';
  } catch (e) {
    _error = 'Unexpected error: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### 8.2 Error Widgets

```dart
// lib/widgets/common/error_widget.dart
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 8.3 User Feedback

```dart
// Show snackbar for errors
void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}

// Show success message
void showSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
    ),
  );
}
```

---

## 9. Testing Guidelines

### 9.1 Unit Tests

```dart
// test/viewmodels/analysis_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AnalysisViewModel', () {
    late AnalysisViewModel viewModel;
    late MockAnalysisRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAnalysisRepository();
      viewModel = AnalysisViewModel(mockRepository);
    });
    
    test('analyzeContent updates state correctly', () async {
      // Arrange
      final mockAnalysis = AnalysisModel(/* ... */);
      when(mockRepository.analyzeContent(any, any))
          .thenAnswer((_) async => mockAnalysis);
      
      // Act
      await viewModel.analyzeContent('test', 'text');
      
      // Assert
      expect(viewModel.isLoading, false);
      expect(viewModel.currentAnalysis, mockAnalysis);
      expect(viewModel.error, null);
    });
  });
}
```

### 9.2 Widget Tests

```dart
// test/widgets/risk_score_widget_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RiskScoreWidget displays correct color', (tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RiskScoreWidget(riskScore: 85),
        ),
      ),
    );
    
    // Find widget
    final widget = find.byType(RiskScoreWidget);
    expect(widget, findsOneWidget);
    
    // Verify color (high risk = red)
    // Add specific assertions based on implementation
  });
}
```

---

## 10. Code Style

### 10.1 Dart Style Guide

Follow official Dart style guide: https://dart.dev/guides/language/effective-dart/style

**Key Rules:**
- Use `lowerCamelCase` for variables and methods
- Use `UpperCamelCase` for classes
- Use `lowercase_with_underscores` for libraries and files
- Prefer `final` over `var` when possible
- Use trailing commas for better formatting

### 10.2 Code Formatting

```bash
# Format all Dart files
dart format .

# Check formatting
dart format --output=none --set-exit-if-changed .
```

### 10.3 Linting

**analysis_options.yaml:**

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - avoid_print
    - prefer_single_quotes
    - require_trailing_commas
    - sort_child_properties_last
```

### 10.4 Comments

```dart
/// Analyzes content for fraud indicators.
///
/// Takes [content] as input and [type] to specify the content type
/// (screenshot, text, or url).
///
/// Returns a [Future] that completes with [AnalysisModel] containing
/// the analysis results.
///
/// Throws [NetworkException] if network request fails.
Future<AnalysisModel> analyzeContent(String content, String type) async {
  // Implementation
}
```

---

## 11. Common Patterns

### 11.1 Loading States

```dart
Widget build(BuildContext context) {
  final viewModel = context.watch<AnalysisViewModel>();
  
  if (viewModel.isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  
  if (viewModel.error != null) {
    return CustomErrorWidget(
      message: viewModel.error!,
      onRetry: () => viewModel.retry(),
    );
  }
  
  if (viewModel.currentAnalysis == null) {
    return const EmptyStateWidget();
  }
  
  return AnalysisResultWidget(analysis: viewModel.currentAnalysis!);
}
```

### 11.2 Form Validation

```dart
class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Process form
      context.read<AuthViewModel>().signUp(
        _emailController.text,
        _passwordController.text,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: Validators.email,
          ),
          TextFormField(
            controller: _passwordController,
            validator: Validators.password,
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
```

### 11.3 Navigation

```dart
// Using go_router
context.go('/dashboard');
context.push('/analyze');
context.pop();

// With parameters
context.go('/analysis/${analysisId}');

// Named routes
context.goNamed('analysis', params: {'id': analysisId});
```

---

## 12. Security Best Practices

### 12.1 Input Validation

```dart
// lib/core/utils/validators.dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain number';
    }
    return null;
  }
}
```

### 12.2 Secure Storage

```dart
// Never store sensitive data in SharedPreferences
// Use flutter_secure_storage for sensitive data

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Store
await storage.write(key: 'api_key', value: apiKey);

// Read
final apiKey = await storage.read(key: 'api_key');
```

---

## Conclusion

These frontend guidelines ensure:
- **Consistent code style** across the project
- **Maintainable architecture** using MVVM
- **Performant UI** with optimization best practices
- **Testable code** with clear separation of concerns
- **Accessible design** for all users

Follow these guidelines throughout development for a high-quality, professional Flutter web application.

---

**Next Steps:**
1. Set up project structure following folder organization
2. Create core utilities and constants
3. Implement base widgets and theme
4. Begin screen development

**Document Version:** 1.0  
**Status:** Ready for Development
