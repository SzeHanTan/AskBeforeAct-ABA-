# AskBeforeAct (ABA) - Tech Stack Document
## Complete Technical Specifications & Dependencies

**Version:** 1.0  
**Last Updated:** February 13, 2026  

---

## Table of Contents

1. [Technology Stack Overview](#1-technology-stack-overview)
2. [Frontend (Flutter Web)](#2-frontend-flutter-web)
3. [Backend (Firebase)](#3-backend-firebase)
4. [AI Integration (Gemini)](#4-ai-integration-gemini)
5. [Development Tools](#5-development-tools)
6. [Deployment](#6-deployment)
7. [API Documentation](#7-api-documentation)
8. [Environment Setup](#8-environment-setup)

---

## 1. Technology Stack Overview

### 1.1 Complete Stack

```
┌─────────────────────────────────────────┐
│         Frontend (Flutter Web)          │
│  Dart 3.2+ | Flutter 3.16+              │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Backend (Firebase)              │
│  Authentication | Firestore | Storage   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         AI Service (Gemini)             │
│  Google Generative AI API               │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         Hosting (Vercel)                │
│  Static Site Deployment                 │
└─────────────────────────────────────────┘
```

### 1.2 Cost Breakdown

| Service | Tier | Limits | Monthly Cost |
|---------|------|--------|--------------|
| Flutter | Free | Unlimited | $0 |
| Firebase Auth | Free | Unlimited users | $0 |
| Firestore | Spark | 50K reads, 20K writes/day | $0 |
| Firebase Storage | Spark | 5GB, 1GB/day transfer | $0 |
| Gemini 1.5 Flash | Free | 15 RPM, 1M tokens/min | $0 |
| Vercel | Hobby | 100GB bandwidth | $0 |
| **Total** | | | **$0/month** |

---

## 2. Frontend (Flutter Web)

### 2.1 Core Framework

**Flutter SDK**
- **Version:** 3.16.0 or higher
- **Channel:** Stable
- **Dart Version:** 3.2.0 or higher
- **Installation:** https://docs.flutter.dev/get-started/install

**Why Flutter Web?**
- Single codebase for web and future mobile apps
- Hot reload for fast development
- Rich widget library (Material Design)
- Strong typing with Dart
- Excellent performance

### 2.2 Required Dependencies

Add these to `pubspec.yaml`:

```yaml
name: askbeforeact
description: AI-powered fraud detection web application
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Core & Services
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  
  # Google AI (Gemini)
  google_generative_ai: ^0.2.1
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^13.0.0
  
  # HTTP & Networking
  http: ^1.2.0
  
  # Image Handling
  image_picker: ^1.0.7
  image_picker_web: ^3.1.1
  file_picker: ^6.1.1
  
  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Utilities
  intl: ^0.19.0
  url_launcher: ^6.2.3
  uuid: ^4.3.3
  shared_preferences: ^2.2.2
  
  # Form Validation
  email_validator: ^2.1.17
  
  # Loading Indicators
  flutter_spinkit: ^5.2.0
  
  # Toast/Snackbar
  fluttertoast: ^8.2.4
  
  # Icons
  cupertino_icons: ^1.0.6
  font_awesome_flutter: ^10.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.8
```

### 2.3 Package Details & Documentation

#### Firebase Packages

**1. firebase_core (^2.24.2)**
- **Purpose:** Initialize Firebase in Flutter app
- **Documentation:** https://pub.dev/packages/firebase_core
- **Usage:**
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**2. firebase_auth (^4.16.0)**
- **Purpose:** User authentication (email, Google OAuth)
- **Documentation:** https://pub.dev/packages/firebase_auth
- **Key Methods:**
  - `createUserWithEmailAndPassword()`
  - `signInWithEmailAndPassword()`
  - `signInWithPopup()` (Google)
  - `signOut()`
  - `sendPasswordResetEmail()`

**3. cloud_firestore (^4.14.0)**
- **Purpose:** NoSQL database operations
- **Documentation:** https://pub.dev/packages/cloud_firestore
- **Key Methods:**
  - `collection().add()` - Create document
  - `collection().doc().get()` - Read document
  - `collection().doc().update()` - Update document
  - `collection().where().get()` - Query documents
  - `snapshots()` - Real-time updates

**4. firebase_storage (^11.6.0)**
- **Purpose:** Upload and store screenshots
- **Documentation:** https://pub.dev/packages/firebase_storage
- **Key Methods:**
  - `ref().putFile()` - Upload file
  - `ref().getDownloadURL()` - Get file URL
  - `ref().delete()` - Delete file

#### AI Package

**5. google_generative_ai (^0.2.1)**
- **Purpose:** Gemini AI integration
- **Documentation:** https://pub.dev/packages/google_generative_ai
- **Official Docs:** https://ai.google.dev/tutorials/dart_quickstart
- **Usage:**
```dart
final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: apiKey,
);
final response = await model.generateContent([
  Content.text(prompt),
]);
```

#### State Management

**6. provider (^6.1.1)**
- **Purpose:** State management across app
- **Documentation:** https://pub.dev/packages/provider
- **Usage:** Manage user auth state, analysis results, community posts
- **Key Classes:**
  - `ChangeNotifier` - Create observable state
  - `ChangeNotifierProvider` - Provide state to widgets
  - `Consumer` - Listen to state changes

#### Navigation

**7. go_router (^13.0.0)**
- **Purpose:** Declarative routing and navigation
- **Documentation:** https://pub.dev/packages/go_router
- **Features:**
  - Deep linking support
  - Route guards (authentication)
  - Nested navigation
  - URL-based routing

#### Image Handling

**8. image_picker (^1.0.7)**
- **Purpose:** Pick images from device
- **Documentation:** https://pub.dev/packages/image_picker

**9. image_picker_web (^3.1.1)**
- **Purpose:** Web-specific image picking
- **Documentation:** https://pub.dev/packages/image_picker_web

**10. file_picker (^6.1.1)**
- **Purpose:** Pick files (screenshots, PDFs)
- **Documentation:** https://pub.dev/packages/file_picker
- **Usage:**
```dart
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.image,
  allowMultiple: false,
);
```

#### UI Components

**11. flutter_svg (^2.0.9)**
- **Purpose:** Display SVG images
- **Documentation:** https://pub.dev/packages/flutter_svg

**12. cached_network_image (^3.3.1)**
- **Purpose:** Cache and display network images
- **Documentation:** https://pub.dev/packages/cached_network_image

**13. shimmer (^3.0.0)**
- **Purpose:** Loading skeleton animations
- **Documentation:** https://pub.dev/packages/shimmer

**14. flutter_spinkit (^5.2.0)**
- **Purpose:** Loading indicators
- **Documentation:** https://pub.dev/packages/flutter_spinkit

#### Utilities

**15. intl (^0.19.0)**
- **Purpose:** Date/time formatting, internationalization
- **Documentation:** https://pub.dev/packages/intl
- **Usage:**
```dart
DateFormat('MMM dd, yyyy').format(DateTime.now());
```

**16. url_launcher (^6.2.3)**
- **Purpose:** Open URLs in browser
- **Documentation:** https://pub.dev/packages/url_launcher

**17. uuid (^4.3.3)**
- **Purpose:** Generate unique IDs
- **Documentation:** https://pub.dev/packages/uuid

**18. shared_preferences (^2.2.2)**
- **Purpose:** Local storage (user preferences)
- **Documentation:** https://pub.dev/packages/shared_preferences

**19. email_validator (^2.1.17)**
- **Purpose:** Validate email addresses
- **Documentation:** https://pub.dev/packages/email_validator

**20. fluttertoast (^8.2.4)**
- **Purpose:** Show toast notifications
- **Documentation:** https://pub.dev/packages/fluttertoast

**21. font_awesome_flutter (^10.7.0)**
- **Purpose:** Font Awesome icons
- **Documentation:** https://pub.dev/packages/font_awesome_flutter

### 2.4 Flutter Web Configuration

**index.html** (web/index.html)
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AskBeforeAct - AI Fraud Detection</title>
  
  <!-- Firebase SDK -->
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-storage-compat.js"></script>
</head>
<body>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

---

## 3. Backend (Firebase)

### 3.1 Firebase Project Setup

**Steps:**
1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter project name: "askbeforeact-mvp"
4. Disable Google Analytics (optional for MVP)
5. Click "Create project"

### 3.2 Firebase Services Configuration

#### 3.2.1 Firebase Authentication

**Enable Authentication Methods:**

1. In Firebase Console → Authentication → Sign-in method
2. Enable:
   - ✅ Email/Password
   - ✅ Google (OAuth)
   - ✅ Anonymous

**Google OAuth Setup:**
- Add authorized domain: `your-app.vercel.app`
- Configure OAuth consent screen in Google Cloud Console
- Copy Web client ID to Flutter app

**Security Rules:**
```javascript
// No additional rules needed - Firebase Auth handles this
```

#### 3.2.2 Cloud Firestore

**Database Structure:**

```
askbeforeact-mvp (project)
└── (default) database
    ├── users/
    │   └── {userId}/
    │       ├── email: string
    │       ├── displayName: string
    │       ├── createdAt: timestamp
    │       ├── analysisCount: number
    │       └── isAnonymous: boolean
    │
    ├── analyses/
    │   └── {analysisId}/
    │       ├── userId: string
    │       ├── type: string ("screenshot" | "text" | "url")
    │       ├── content: string (URL or text)
    │       ├── riskScore: number (0-100)
    │       ├── riskLevel: string ("low" | "medium" | "high")
    │       ├── scamType: string
    │       ├── redFlags: array<string>
    │       ├── recommendations: array<string>
    │       ├── confidence: string ("low" | "medium" | "high")
    │       └── createdAt: timestamp
    │
    ├── communityPosts/
    │   └── {postId}/
    │       ├── userId: string
    │       ├── userName: string
    │       ├── isAnonymous: boolean
    │       ├── scamType: string
    │       ├── content: string (max 500 chars)
    │       ├── upvotes: number
    │       ├── downvotes: number
    │       ├── netVotes: number (upvotes - downvotes)
    │       ├── voters: map<userId, "up"|"down">
    │       ├── reported: boolean
    │       ├── reportCount: number
    │       └── createdAt: timestamp
    │
    └── educationContent/
        └── {scamTypeId}/
            ├── title: string
            ├── description: string
            ├── icon: string (emoji or URL)
            ├── warningSigns: array<string>
            ├── preventionTips: array<string>
            ├── example: string
            └── order: number
```

**Firestore Security Rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() && request.auth.uid == userId;
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Analyses collection
    match /analyses/{analysisId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() && request.resource.data.userId == request.auth.uid;
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Community posts
    match /communityPosts/{postId} {
      allow read: if true; // Public read
      allow create: if isSignedIn() 
        && request.resource.data.userId == request.auth.uid
        && request.resource.data.content.size() <= 500;
      allow update: if isSignedIn(); // For voting
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Education content (read-only for users)
    match /educationContent/{docId} {
      allow read: if true;
      allow write: if false; // Admin only (via Firebase Console)
    }
  }
}
```

**Firestore Indexes:**

Create composite indexes for queries:

1. **Community Posts by Type and Date:**
   - Collection: `communityPosts`
   - Fields: `scamType` (Ascending), `createdAt` (Descending)

2. **Analyses by User and Date:**
   - Collection: `analyses`
   - Fields: `userId` (Ascending), `createdAt` (Descending)

3. **Community Posts by Votes:**
   - Collection: `communityPosts`
   - Fields: `netVotes` (Descending), `createdAt` (Descending)

**Create via Firebase Console:**
- Firestore Database → Indexes → Add Index

#### 3.2.3 Firebase Storage

**Bucket Structure:**

```
askbeforeact-mvp.appspot.com/
└── screenshots/
    └── {userId}/
        └── {analysisId}.jpg
```

**Storage Security Rules:**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Screenshots
    match /screenshots/{userId}/{analysisId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null 
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024 // 5MB limit
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

**Storage Configuration:**
- Max file size: 5MB
- Allowed types: image/jpeg, image/png
- Auto-delete after 90 days (optional, set via lifecycle rules)

### 3.3 Firebase Configuration Files

**firebase_options.dart** (generated by FlutterFire CLI)

```dart
// This file is generated by FlutterFire CLI
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'askbeforeact-mvp',
    authDomain: 'askbeforeact-mvp.firebaseapp.com',
    storageBucket: 'askbeforeact-mvp.appspot.com',
  );
}
```

**Generate this file:**
```bash
flutterfire configure
```

---

## 4. AI Integration (Gemini)

### 4.1 Google AI Studio Setup

**Get API Key:**

1. Go to https://makersuite.google.com/app/apikey
2. Click "Create API Key"
3. Select project: "askbeforeact-mvp"
4. Copy API key
5. Store in environment variables (never commit to Git)

### 4.2 Gemini 1.5 Flash Specifications

**Model Details:**
- **Model ID:** `gemini-1.5-flash`
- **Context Window:** 1 million tokens
- **Max Output:** 8,192 tokens
- **Multimodal:** Text + Images
- **Speed:** ~2-5 seconds per request

**Free Tier Limits:**
- 15 requests per minute (RPM)
- 1 million tokens per minute (TPM)
- 1,500 requests per day (RPD)

**Pricing (if exceeding free tier):**
- Input: $0.075 per 1M tokens
- Output: $0.30 per 1M tokens
- Images: $0.00315 per image

**Documentation:**
- Official Docs: https://ai.google.dev/docs
- Dart SDK: https://pub.dev/packages/google_generative_ai
- API Reference: https://ai.google.dev/api/rest

### 4.3 Gemini API Usage

**Initialize Model:**

```dart
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    temperature: 0.4, // Lower = more consistent
    topK: 32,
    topP: 1,
    maxOutputTokens: 2048,
  ),
);
```

**Text Analysis:**

```dart
final prompt = '''
You are a fraud detection expert. Analyze the following content for potential fraud indicators.

Content Type: text
Content: "${userInput}"

Provide a JSON response with:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "other",
  "redFlags": ["flag1", "flag2", ...],
  "recommendations": ["action1", "action2", ...],
  "confidence": "low" | "medium" | "high"
}

Be specific and cite evidence from the content.
''';

final response = await model.generateContent([Content.text(prompt)]);
final jsonResponse = jsonDecode(response.text!);
```

**Image Analysis:**

```dart
final imageBytes = await file.readAsBytes();

final prompt = '''
Analyze this screenshot for fraud indicators. Look for:
- Suspicious URLs or domains
- Urgency tactics
- Requests for personal information
- Impersonation of legitimate companies
- Poor grammar or spelling

Provide JSON response with riskScore, scamType, redFlags, recommendations.
''';

final response = await model.generateContent([
  Content.multi([
    TextPart(prompt),
    DataPart('image/jpeg', imageBytes),
  ])
]);
```

**URL Analysis:**

```dart
final prompt = '''
Analyze this URL for safety: ${userUrl}

Check for:
- Domain reputation
- HTTPS presence
- Suspicious patterns (typosquatting, etc.)
- Known phishing indicators

Provide JSON response.
''';
```

### 4.4 Prompt Engineering Best Practices

**Structured Prompts:**
- Always request JSON output
- Specify exact field names and types
- Provide examples of expected output
- Set temperature low (0.3-0.5) for consistency

**Error Handling:**
- Wrap API calls in try-catch
- Handle rate limits (429 errors)
- Retry with exponential backoff
- Fallback to generic response if parsing fails

---

## 5. Development Tools

### 5.1 Required Software

| Tool | Version | Purpose | Download |
|------|---------|---------|----------|
| **Flutter SDK** | 3.16.0+ | Framework | https://flutter.dev/docs/get-started/install |
| **Dart SDK** | 3.2.0+ | Language (included with Flutter) | - |
| **VS Code** | Latest | IDE | https://code.visualstudio.com/ |
| **Git** | Latest | Version control | https://git-scm.com/ |
| **Node.js** | 18+ | Firebase CLI | https://nodejs.org/ |
| **Firebase CLI** | Latest | Firebase tools | `npm install -g firebase-tools` |
| **FlutterFire CLI** | Latest | Firebase config | `dart pub global activate flutterfire_cli` |

### 5.2 VS Code Extensions

**Essential:**
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Firebase Explorer (jsayol.firebase-explorer)
- Error Lens (usernamehw.errorlens)
- Prettier (esbenp.prettier-vscode)

**Optional:**
- GitLens (eamodio.gitlens)
- TODO Highlight (wayou.vscode-todo-highlight)
- Bracket Pair Colorizer (CoenraadS.bracket-pair-colorizer-2)

### 5.3 Development Commands

```bash
# Check Flutter installation
flutter doctor

# Create new Flutter project
flutter create askbeforeact --platforms web

# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome

# Build for web
flutter build web --release

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze
```

---

## 6. Deployment

### 6.1 Vercel Deployment

**Setup:**

1. **Install Vercel CLI:**
```bash
npm install -g vercel
```

2. **Login to Vercel:**
```bash
vercel login
```

3. **Build Flutter Web:**
```bash
flutter build web --release
```

4. **Deploy:**
```bash
cd build/web
vercel --prod
```

**vercel.json** (in project root):

```json
{
  "version": 2,
  "name": "askbeforeact",
  "builds": [
    {
      "src": "build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/build/web/$1"
    }
  ]
}
```

**Automatic Deployment:**

1. Connect GitHub repo to Vercel
2. Set build command: `flutter build web --release`
3. Set output directory: `build/web`
4. Auto-deploy on push to `main` branch

### 6.2 Environment Variables

**Vercel Environment Variables:**

Add in Vercel Dashboard → Settings → Environment Variables:

```
GEMINI_API_KEY=your_api_key_here
```

**Access in Flutter:**

```dart
// Use flutter_dotenv package for local dev
// For production, inject via build args or fetch from secure endpoint
```

**Security Note:** 
- Never commit API keys to Git
- Use `.env` file for local development (add to `.gitignore`)
- For production, consider backend proxy for API calls

---

## 7. API Documentation

### 7.1 Firebase APIs (Used by Flutter)

All Firebase operations are handled client-side via Flutter packages. No custom backend APIs needed for MVP.

**Authentication API:**
- Sign up: `FirebaseAuth.instance.createUserWithEmailAndPassword()`
- Sign in: `FirebaseAuth.instance.signInWithEmailAndPassword()`
- Sign out: `FirebaseAuth.instance.signOut()`

**Firestore API:**
- Create: `FirebaseFirestore.instance.collection('analyses').add(data)`
- Read: `FirebaseFirestore.instance.collection('analyses').doc(id).get()`
- Update: `FirebaseFirestore.instance.collection('analyses').doc(id).update(data)`
- Delete: `FirebaseFirestore.instance.collection('analyses').doc(id).delete()`
- Query: `FirebaseFirestore.instance.collection('analyses').where('userId', isEqualTo: uid).get()`

**Storage API:**
- Upload: `FirebaseStorage.instance.ref('screenshots/$userId/$id.jpg').putFile(file)`
- Download URL: `ref.getDownloadURL()`
- Delete: `ref.delete()`

### 7.2 Gemini API

**Endpoint:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent`

**Request Format:**
```json
{
  "contents": [
    {
      "parts": [
        {"text": "Your prompt here"}
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.4,
    "maxOutputTokens": 2048
  }
}
```

**Response Format:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {"text": "AI response here"}
        ]
      }
    }
  ]
}
```

**Error Codes:**
- 400: Invalid request
- 429: Rate limit exceeded
- 500: Server error

---

## 8. Environment Setup

### 8.1 Initial Setup Checklist

**Step 1: Install Flutter**
```bash
# Download Flutter SDK from flutter.dev
# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Step 2: Create Firebase Project**
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Create project via console.firebase.google.com
```

**Step 3: Configure Flutter for Firebase**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

**Step 4: Get Gemini API Key**
- Visit https://makersuite.google.com/app/apikey
- Create API key
- Store securely

**Step 5: Clone and Setup Project**
```bash
# Clone repo
git clone <your-repo-url>
cd askbeforeact

# Install dependencies
flutter pub get

# Run app
flutter run -d chrome
```

### 8.2 Environment Variables

**Create `.env` file** (add to `.gitignore`):

```
GEMINI_API_KEY=your_gemini_api_key_here
FIREBASE_API_KEY=your_firebase_api_key
```

**Load in Flutter:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load(fileName: ".env");
final apiKey = dotenv.env['GEMINI_API_KEY'];
```

### 8.3 Firebase Emulator (Optional for Local Dev)

```bash
# Install emulators
firebase init emulators

# Select: Authentication, Firestore, Storage

# Start emulators
firebase emulators:start
```

**Connect Flutter to emulators:**

```dart
if (kDebugMode) {
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
}
```

---

## 9. Testing

### 9.1 Unit Tests

```bash
flutter test
```

**Test Files:**
- `test/services/ai_service_test.dart`
- `test/services/auth_service_test.dart`
- `test/models/analysis_test.dart`

### 9.2 Widget Tests

```bash
flutter test test/widgets/
```

### 9.3 Integration Tests

```bash
flutter test integration_test/
```

---

## 10. Monitoring & Analytics

### 10.1 Firebase Analytics (Optional)

```yaml
# Add to pubspec.yaml
firebase_analytics: ^10.8.0
```

**Track Events:**
```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'analysis_completed',
  parameters: {'risk_level': 'high'},
);
```

### 10.2 Error Tracking

**Sentry (Optional):**

```yaml
sentry_flutter: ^7.14.0
```

```dart
await SentryFlutter.init(
  (options) => options.dsn = 'your-dsn',
  appRunner: () => runApp(MyApp()),
);
```

---

## 11. Security Considerations

### 11.1 API Key Security

- ✅ Store Gemini API key in environment variables
- ✅ Never commit keys to Git
- ✅ Use Firebase Security Rules to protect data
- ✅ Implement rate limiting on client side
- ✅ Validate all user inputs

### 11.2 Data Privacy

- ✅ Encrypt screenshots in Firebase Storage
- ✅ Auto-delete analyses after 90 days (optional)
- ✅ Allow users to delete their data
- ✅ Don't store sensitive info from analyzed content

---

## Conclusion

This tech stack provides a complete, zero-cost solution for the AskBeforeAct MVP:

- **Flutter Web:** Fast, modern frontend
- **Firebase:** Scalable backend with auth, database, and storage
- **Gemini 1.5 Flash:** Powerful AI for fraud detection
- **Vercel:** Fast, reliable hosting

All services remain free within their generous tier limits, making this perfect for MVP launch and early growth.

---

**Next Steps:**
1. Set up development environment
2. Create Firebase project and configure services
3. Get Gemini API key
4. Begin coding following the file structure document

**Document Version:** 1.0  
**Status:** Ready for Development
