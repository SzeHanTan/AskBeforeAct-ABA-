# AskBeforeAct (ABA) - File Structure Document
## Complete Project File Organization

**Version:** 1.0  
**Last Updated:** February 13, 2026  

---

## Table of Contents

1. [Project Root Structure](#1-project-root-structure)
2. [Lib Directory Structure](#2-lib-directory-structure)
3. [Assets Directory](#3-assets-directory)
4. [Web Directory](#4-web-directory)
5. [Test Directory](#5-test-directory)
6. [Configuration Files](#6-configuration-files)
7. [File Naming Conventions](#7-file-naming-conventions)
8. [Import Structure](#8-import-structure)

---

## 1. Project Root Structure

```
askbeforeact/
├── .dart_tool/                 # Dart tooling (auto-generated)
├── .firebase/                  # Firebase config (auto-generated)
├── .git/                       # Git repository
├── .idea/                      # IDE settings (optional)
├── .vscode/                    # VS Code settings
├── android/                    # Android platform (not used in MVP)
├── assets/                     # Static assets (images, icons, etc.)
├── build/                      # Build output (auto-generated)
├── ios/                        # iOS platform (not used in MVP)
├── lib/                        # Main application code
├── test/                       # Unit and widget tests
├── web/                        # Web-specific files
├── .env                        # Environment variables (DO NOT COMMIT)
├── .env.example                # Example env file (commit this)
├── .gitignore                  # Git ignore rules
├── .metadata                   # Flutter metadata
├── analysis_options.yaml       # Dart analyzer configuration
├── firebase.json               # Firebase configuration
├── firestore.indexes.json      # Firestore indexes
├── firestore.rules             # Firestore security rules
├── pubspec.lock                # Dependency lock file
├── pubspec.yaml                # Project dependencies
├── README.md                   # Project documentation
├── storage.rules               # Firebase Storage security rules
└── vercel.json                 # Vercel deployment config
```

---

## 2. Lib Directory Structure

```
lib/
├── main.dart                           # App entry point
├── app.dart                            # Root app widget with providers
├── firebase_options.dart               # Firebase configuration (auto-generated)
│
├── core/                               # Core utilities and constants
│   ├── constants/
│   │   ├── app_colors.dart            # Color palette
│   │   ├── app_strings.dart           # Text strings and labels
│   │   ├── app_routes.dart            # Route names
│   │   └── app_constants.dart         # General constants
│   ├── theme/
│   │   ├── app_theme.dart             # Theme configuration
│   │   └── text_styles.dart           # Text style definitions
│   ├── utils/
│   │   ├── validators.dart            # Form validators
│   │   ├── formatters.dart            # Date/text formatters
│   │   ├── helpers.dart               # Helper functions
│   │   └── responsive.dart            # Responsive utilities
│   ├── config/
│   │   └── env_config.dart            # Environment configuration
│   └── exceptions/
│       ├── app_exception.dart         # Base exception
│       ├── auth_exception.dart        # Auth-specific exceptions
│       └── network_exception.dart     # Network exceptions
│
├── models/                             # Data models
│   ├── user_model.dart                # User data model
│   ├── analysis_model.dart            # Analysis result model
│   ├── community_post_model.dart      # Community post model
│   └── education_content_model.dart   # Education content model
│
├── services/                           # External services
│   ├── auth_service.dart              # Firebase Authentication
│   ├── user_service.dart              # User profile management
│   ├── firestore_service.dart         # Firestore operations
│   ├── storage_service.dart           # Firebase Storage
│   ├── ai_service.dart                # Gemini AI integration
│   ├── analysis_service.dart          # Analysis operations
│   ├── community_service.dart         # Community operations
│   └── analytics_service.dart         # Analytics (optional)
│
├── repositories/                       # Data layer (repository pattern)
│   ├── user_repository.dart           # User data repository
│   ├── analysis_repository.dart       # Analysis data repository
│   ├── community_repository.dart      # Community data repository
│   └── education_repository.dart      # Education data repository
│
├── viewmodels/                         # Business logic (MVVM)
│   ├── auth_viewmodel.dart            # Authentication logic
│   ├── analysis_viewmodel.dart        # Analysis logic
│   ├── history_viewmodel.dart         # History logic
│   ├── community_viewmodel.dart       # Community logic
│   ├── education_viewmodel.dart       # Education logic
│   └── profile_viewmodel.dart         # Profile logic
│
├── views/                              # UI screens
│   ├── auth/
│   │   ├── login_screen.dart          # Login page
│   │   ├── signup_screen.dart         # Sign up page
│   │   └── reset_password_screen.dart # Password reset page
│   ├── home/
│   │   ├── landing_screen.dart        # Landing page (unauthenticated)
│   │   ├── dashboard_screen.dart      # Dashboard (authenticated)
│   │   └── onboarding_screen.dart     # First-time user onboarding
│   ├── analysis/
│   │   ├── analyze_screen.dart        # Analysis input page
│   │   ├── results_screen.dart        # Analysis results page
│   │   ├── history_screen.dart        # Analysis history list
│   │   └── analysis_detail_screen.dart # Single analysis detail
│   ├── community/
│   │   ├── community_screen.dart      # Community feed
│   │   └── widgets/
│   │       └── create_post_modal.dart # Post creation modal
│   ├── education/
│   │   ├── education_screen.dart      # Education library
│   │   └── education_detail_screen.dart # Single guide detail
│   └── profile/
│       └── profile_screen.dart        # User profile page
│
└── widgets/                            # Reusable widgets
    ├── common/
    │   ├── custom_button.dart         # Reusable button
    │   ├── custom_text_field.dart     # Reusable text input
    │   ├── custom_app_bar.dart        # Reusable app bar
    │   ├── loading_indicator.dart     # Loading spinner
    │   ├── error_widget.dart          # Error display
    │   ├── empty_state_widget.dart    # Empty state display
    │   └── bottom_nav_bar.dart        # Bottom navigation
    ├── analysis/
    │   ├── risk_score_widget.dart     # Risk score display
    │   ├── risk_badge.dart            # Risk level badge
    │   ├── red_flags_list.dart        # Red flags list
    │   ├── recommendations_list.dart  # Recommendations list
    │   ├── analysis_card.dart         # Analysis summary card
    │   └── upload_widget.dart         # File upload widget
    ├── community/
    │   ├── post_card.dart             # Community post card
    │   ├── vote_buttons.dart          # Upvote/downvote buttons
    │   └── scam_type_badge.dart       # Scam type badge
    └── education/
        └── education_card.dart        # Education guide card
```

---

## 3. Assets Directory

```
assets/
├── images/
│   ├── logo.png                       # App logo
│   ├── logo_white.png                 # White version for dark backgrounds
│   ├── hero_illustration.png          # Landing page hero image
│   ├── onboarding_1.png               # Onboarding slide 1
│   ├── onboarding_2.png               # Onboarding slide 2
│   ├── onboarding_3.png               # Onboarding slide 3
│   ├── empty_state_analysis.png       # Empty state for no analyses
│   └── empty_state_community.png      # Empty state for no posts
│
├── icons/
│   ├── phishing.png                   # Phishing icon
│   ├── romance.png                    # Romance scam icon
│   ├── payment.png                    # Payment fraud icon
│   ├── job.png                        # Job scam icon
│   └── tech_support.png               # Tech support scam icon
│
└── data/
    └── education_content.json         # Static education content
```

**assets/data/education_content.json:**

```json
[
  {
    "id": "phishing",
    "title": "Phishing Emails",
    "description": "Fraudulent emails designed to steal personal information",
    "icon": "📧",
    "warningSigns": [
      "Urgent language demanding immediate action",
      "Suspicious sender email address",
      "Generic greetings like 'Dear Customer'",
      "Requests for personal or financial information",
      "Poor grammar and spelling errors"
    ],
    "preventionTips": [
      "Verify sender email address carefully",
      "Never click suspicious links",
      "Check for HTTPS in website URLs",
      "Contact company directly if unsure",
      "Use email filters and spam protection"
    ],
    "example": "Subject: URGENT: Your account will be suspended!\n\nDear Customer,\n\nYour PayPal account has been limited due to suspicious activity. Click here immediately to verify your information or your account will be permanently closed within 24 hours.\n\nClick here: http://paypa1-verify.com/login\n\nThank you,\nPayPal Security Team",
    "order": 1
  },
  {
    "id": "romance",
    "title": "Romance Scams",
    "description": "Scammers create fake romantic relationships to steal money",
    "icon": "💔",
    "warningSigns": [
      "Professes love very quickly",
      "Avoids video calls or in-person meetings",
      "Claims to be overseas or in military",
      "Asks for money for emergencies",
      "Stories seem too dramatic or perfect"
    ],
    "preventionTips": [
      "Be cautious of online relationships that move too fast",
      "Never send money to someone you haven't met",
      "Do reverse image searches on profile photos",
      "Be skeptical of sob stories",
      "Tell friends and family about new relationships"
    ],
    "example": "My dearest love,\n\nI can't believe how lucky I am to have found you. You are my soulmate and I dream of the day we can finally be together. Unfortunately, I have a problem - my business deal fell through and I'm stuck in Nigeria without money to get home. Could you wire me $5,000? I promise to pay you back as soon as I return. I love you so much!\n\nForever yours,\nJohn",
    "order": 2
  },
  {
    "id": "payment",
    "title": "Payment Fraud",
    "description": "Scams involving fake payments, overpayments, or fraudulent transactions",
    "icon": "💳",
    "warningSigns": [
      "Buyer offers to pay more than asking price",
      "Requests unusual payment methods (gift cards, wire transfer)",
      "Asks you to pay fees to receive money",
      "Check bounces after you've shipped item",
      "Pressure to complete transaction quickly"
    ],
    "preventionTips": [
      "Use secure payment platforms with buyer protection",
      "Never accept overpayments",
      "Avoid wire transfers to strangers",
      "Wait for checks to clear before shipping",
      "Be wary of gift card payment requests"
    ],
    "example": "Hello,\n\nI am interested in purchasing your laptop for $800. However, I am currently overseas and will send you a check for $1,200. Please ship the laptop and send the extra $400 to my shipping agent via Western Union. This is urgent as I need it for my son's birthday.\n\nThank you,\nMichael",
    "order": 3
  },
  {
    "id": "job",
    "title": "Job Scams",
    "description": "Fake job offers designed to steal money or personal information",
    "icon": "💼",
    "warningSigns": [
      "Job offer without interview",
      "Asks for money upfront for training or equipment",
      "Promises unrealistic salary for minimal work",
      "Requests personal information before hiring",
      "Uses free email addresses (Gmail, Yahoo)"
    ],
    "preventionTips": [
      "Research company thoroughly before applying",
      "Never pay for a job opportunity",
      "Be skeptical of work-from-home offers",
      "Verify job postings on company's official website",
      "Don't provide SSN or bank info before hiring"
    ],
    "example": "Congratulations!\n\nYou have been selected for a Work From Home position as a Payment Processing Agent. Salary: $5,000/month for just 2 hours of work per day!\n\nTo get started, please send $150 for your starter kit and training materials. Once received, we will send you your first assignment.\n\nStart earning today!\nGlobal Employment Solutions",
    "order": 4
  },
  {
    "id": "tech_support",
    "title": "Tech Support Scams",
    "description": "Fake tech support claiming your computer has problems",
    "icon": "💻",
    "warningSigns": [
      "Unsolicited calls about computer problems",
      "Pop-ups claiming your computer is infected",
      "Requests remote access to your computer",
      "Demands immediate payment",
      "Claims to be from Microsoft, Apple, etc."
    ],
    "preventionTips": [
      "Legitimate companies don't call unsolicited",
      "Never give remote access to strangers",
      "Close suspicious pop-ups without clicking",
      "Use trusted antivirus software",
      "Contact companies directly using official numbers"
    ],
    "example": "WARNING! Your computer has been infected with a virus!\n\nYour Windows license has expired and your computer is at risk. Call Microsoft Support immediately at 1-800-FAKE-NUM to renew your license and remove viruses.\n\nDo not shut down your computer or you will lose all your data!\n\n[OK] [Call Now]",
    "order": 5
  }
]
```

---

## 4. Web Directory

```
web/
├── favicon.png                        # Browser tab icon
├── icons/
│   ├── Icon-192.png                   # PWA icon 192x192
│   ├── Icon-512.png                   # PWA icon 512x512
│   └── Icon-maskable-192.png          # Maskable icon
├── index.html                         # Main HTML file
└── manifest.json                      # PWA manifest
```

**web/index.html:**

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="AI-powered fraud detection to protect you from online scams">
  <meta name="keywords" content="fraud detection, scam prevention, AI, phishing">
  
  <title>AskBeforeAct - AI Fraud Detection</title>
  
  <link rel="icon" type="image/png" href="favicon.png"/>
  <link rel="manifest" href="manifest.json">
  
  <!-- Firebase SDK -->
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-storage-compat.js"></script>
  
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
    }
    
    #loading {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background-color: #F9FAFB;
    }
    
    .spinner {
      width: 50px;
      height: 50px;
      border: 4px solid #E5E7EB;
      border-top: 4px solid #2563EB;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <div id="loading">
    <div class="spinner"></div>
  </div>
  
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

**web/manifest.json:**

```json
{
  "name": "AskBeforeAct",
  "short_name": "ABA",
  "start_url": ".",
  "display": "standalone",
  "background_color": "#FFFFFF",
  "theme_color": "#2563EB",
  "description": "AI-powered fraud detection",
  "orientation": "portrait-primary",
  "prefer_related_applications": false,
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-maskable-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

---

## 5. Test Directory

```
test/
├── models/
│   ├── user_model_test.dart           # User model tests
│   ├── analysis_model_test.dart       # Analysis model tests
│   └── community_post_model_test.dart # Community post model tests
│
├── services/
│   ├── auth_service_test.dart         # Auth service tests
│   ├── firestore_service_test.dart    # Firestore service tests
│   └── ai_service_test.dart           # AI service tests
│
├── viewmodels/
│   ├── auth_viewmodel_test.dart       # Auth viewmodel tests
│   ├── analysis_viewmodel_test.dart   # Analysis viewmodel tests
│   └── community_viewmodel_test.dart  # Community viewmodel tests
│
├── widgets/
│   ├── risk_score_widget_test.dart    # Risk score widget tests
│   ├── custom_button_test.dart        # Custom button tests
│   └── post_card_test.dart            # Post card widget tests
│
└── test_helpers.dart                   # Test utilities and mocks
```

---

## 6. Configuration Files

### 6.1 pubspec.yaml

```yaml
name: askbeforeact
description: AI-powered fraud detection web application
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  
  # Google AI
  google_generative_ai: ^0.2.1
  
  # State Management
  provider: ^6.1.1
  
  # Navigation
  go_router: ^13.0.0
  
  # HTTP
  http: ^1.2.0
  
  # Image Handling
  image_picker: ^1.0.7
  image_picker_web: ^3.1.1
  file_picker: ^6.1.1
  
  # UI
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  flutter_spinkit: ^5.2.0
  
  # Utilities
  intl: ^0.19.0
  url_launcher: ^6.2.3
  uuid: ^4.3.3
  shared_preferences: ^2.2.2
  email_validator: ^2.1.17
  fluttertoast: ^8.2.4
  
  # Icons
  cupertino_icons: ^1.0.6
  font_awesome_flutter: ^10.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.8
  mockito: ^5.4.4

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/data/
```

### 6.2 analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Style
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - prefer_single_quotes
    - require_trailing_commas
    - sort_child_properties_last
    
    # Best practices
    - avoid_print
    - avoid_unnecessary_containers
    - avoid_web_libraries_in_flutter
    - use_key_in_widget_constructors
    - sized_box_for_whitespace
    - use_full_hex_values_for_flutter_colors
    
    # Errors
    - avoid_empty_else
    - avoid_returning_null_for_future
    - cancel_subscriptions
    - close_sinks
    - valid_regexps

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  
  errors:
    invalid_annotation_target: ignore
```

### 6.3 .gitignore

```
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# VS Code
.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Environment variables
.env
.env.local
.env.*.local

# Firebase
.firebase/
firebase-debug.log
firestore-debug.log

# Coverage
coverage/
```

### 6.4 .env.example

```
# Gemini AI API Key
GEMINI_API_KEY=your_api_key_here

# Firebase Configuration (optional, can use firebase_options.dart)
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_project_id
```

### 6.5 firebase.json

```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### 6.6 firestore.indexes.json

```json
{
  "indexes": [
    {
      "collectionGroup": "communityPosts",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "scamType",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "analyses",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "userId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "communityPosts",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "netVotes",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": []
}
```

### 6.7 vercel.json

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
  ],
  "env": {
    "GEMINI_API_KEY": "@gemini_api_key"
  }
}
```

### 6.8 README.md

```markdown
# AskBeforeAct (ABA)

AI-powered fraud detection web application built with Flutter and Firebase.

## Features

- 🤖 AI-powered fraud detection using Gemini 1.5 Flash
- 📸 Analyze screenshots, text, and URLs
- 📊 Instant risk scoring and recommendations
- 👥 Community platform for sharing experiences
- 📚 Educational resources about fraud types

## Tech Stack

- **Frontend:** Flutter Web
- **Backend:** Firebase (Auth, Firestore, Storage)
- **AI:** Google Gemini 1.5 Flash
- **Hosting:** Vercel

## Getting Started

### Prerequisites

- Flutter SDK 3.16+
- Dart SDK 3.2+
- Firebase account
- Gemini API key

### Installation

1. Clone the repository
```bash
git clone <repo-url>
cd askbeforeact
```

2. Install dependencies
```bash
flutter pub get
```

3. Set up Firebase
```bash
flutterfire configure
```

4. Create `.env` file
```bash
cp .env.example .env
# Add your Gemini API key
```

5. Run the app
```bash
flutter run -d chrome
```

## Project Structure

See [06_FILE_STRUCTURE.md](06_FILE_STRUCTURE.md) for detailed file organization.

## Documentation

- [PRD](01_PRD_MVP.md) - Product Requirements Document
- [User Flow](02_USER_FLOW.md) - Page-by-page user flows
- [Tech Stack](03_TECH_STACK.md) - Technical specifications
- [Frontend Guidelines](04_FRONTEND_GUIDELINES.md) - Coding standards
- [Backend Structure](05_BACKEND_STRUCTURE.md) - Backend architecture
- [File Structure](06_FILE_STRUCTURE.md) - Project organization

## Deployment

### Build for production
```bash
flutter build web --release
```

### Deploy to Vercel
```bash
vercel --prod
```

## License

MIT License

## Contact

Your Name - your.email@example.com
```

---

## 7. File Naming Conventions

### 7.1 Dart Files

| Type | Convention | Example |
|------|-----------|---------|
| **Screens** | `{name}_screen.dart` | `login_screen.dart` |
| **Widgets** | `{name}_widget.dart` or `{name}.dart` | `risk_score_widget.dart` |
| **Models** | `{name}_model.dart` | `user_model.dart` |
| **Services** | `{name}_service.dart` | `auth_service.dart` |
| **ViewModels** | `{name}_viewmodel.dart` | `analysis_viewmodel.dart` |
| **Repositories** | `{name}_repository.dart` | `user_repository.dart` |
| **Constants** | `app_{name}.dart` | `app_colors.dart` |
| **Utils** | `{name}.dart` | `validators.dart` |

### 7.2 Asset Files

| Type | Convention | Example |
|------|-----------|---------|
| **Images** | `lowercase_with_underscores.png` | `hero_illustration.png` |
| **Icons** | `{name}.png` | `phishing.png` |
| **Data** | `{name}.json` | `education_content.json` |

---

## 8. Import Structure

### 8.1 Import Order in Dart Files

```dart
// 1. Dart core imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// 4. Project imports (alphabetical)
import 'package:askbeforeact/core/constants/app_colors.dart';
import 'package:askbeforeact/models/user_model.dart';
import 'package:askbeforeact/services/auth_service.dart';
import 'package:askbeforeact/viewmodels/auth_viewmodel.dart';
import 'package:askbeforeact/widgets/common/custom_button.dart';
```

### 8.2 Relative vs Absolute Imports

**Use absolute imports for project files:**

```dart
// Good
import 'package:askbeforeact/models/user_model.dart';

// Avoid
import '../models/user_model.dart';
```

---

## 9. Key Files Content Examples

### 9.1 main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### 9.2 app.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/config/router_config.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/analysis_viewmodel.dart';
import 'viewmodels/community_viewmodel.dart';
import 'services/auth_service.dart';
import 'services/analysis_service.dart';
import 'services/community_service.dart';
import 'repositories/analysis_repository.dart';
import 'repositories/community_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => AnalysisService()),
        Provider(create: (_) => CommunityService()),
        
        // Repositories
        Provider(create: (context) => AnalysisRepository(
          context.read<AnalysisService>(),
        )),
        Provider(create: (context) => CommunityRepository(
          context.read<CommunityService>(),
        )),
        
        // ViewModels
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AnalysisViewModel(
            context.read<AnalysisRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CommunityViewModel(
            context.read<CommunityRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'AskBeforeAct',
        theme: AppTheme.lightTheme,
        routerConfig: routerConfig,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

### 9.3 core/config/router_config.dart

```dart
import 'package:go_router/go_router.dart';

import '../../views/auth/login_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/home/landing_screen.dart';
import '../../views/home/dashboard_screen.dart';
import '../../views/analysis/analyze_screen.dart';
import '../../views/analysis/results_screen.dart';
import '../../views/community/community_screen.dart';
import '../../views/education/education_screen.dart';
import '../../views/profile/profile_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/analyze',
      builder: (context, state) => const AnalyzeScreen(),
    ),
    GoRoute(
      path: '/results/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ResultsScreen(analysisId: id);
      },
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const CommunityScreen(),
    ),
    GoRoute(
      path: '/education',
      builder: (context, state) => const EducationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
```

---

## 10. Development Workflow

### 10.1 Creating a New Feature

1. **Create model** in `lib/models/`
2. **Create service** in `lib/services/`
3. **Create repository** in `lib/repositories/`
4. **Create viewmodel** in `lib/viewmodels/`
5. **Create screen** in `lib/views/`
6. **Create widgets** in `lib/widgets/`
7. **Add route** in `router_config.dart`
8. **Write tests** in `test/`

### 10.2 File Creation Checklist

When creating a new screen:
- [ ] Create screen file in appropriate `views/` subfolder
- [ ] Create viewmodel if needed
- [ ] Create reusable widgets in `widgets/`
- [ ] Add route to `router_config.dart`
- [ ] Write widget tests
- [ ] Update documentation if needed

---

## Conclusion

This file structure provides:

- **Clear organization** by feature and layer
- **Scalable architecture** for future growth
- **Easy navigation** for developers
- **Consistent naming** across the project
- **Separation of concerns** (MVVM pattern)
- **Testable code** with dedicated test directory

Follow this structure throughout development to maintain code quality and organization.

---

**Next Steps:**
1. Create project using `flutter create askbeforeact --platforms web`
2. Set up folder structure as documented
3. Create core files (constants, theme, utils)
4. Begin feature development

**Document Version:** 1.0  
**Status:** Ready for Development
