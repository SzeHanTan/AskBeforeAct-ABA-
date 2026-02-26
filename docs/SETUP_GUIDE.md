# AskBeforeAct - Setup Guide 🚀

## Prerequisites
- ✅ Flutter SDK installed
- ✅ Firebase project created
- ✅ Firebase configuration files added (`firebase_options.dart`)
- ✅ Gemini API key configured (`lib/core/config/env_config.dart`)

---

## Quick Start

### 1. Install Dependencies
```bash
cd askbeforeact
flutter pub get
```

### 2. Configure Firebase Security Rules

#### Firestore Rules
Go to Firebase Console → Firestore Database → Rules and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Analyses collection
    match /analyses/{analysisId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Community posts collection
    match /communityPosts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Education content (read-only for all authenticated users)
    match /educationContent/{docId} {
      allow read: if request.auth != null;
      allow write: if false; // Only admins via Firebase Console
    }
  }
}
```

#### Storage Rules
Go to Firebase Console → Storage → Rules and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Screenshots
    match /screenshots/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
    
    // Uploads
    match /uploads/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId
                   && request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
  }
}
```

### 3. Enable Authentication Methods

Go to Firebase Console → Authentication → Sign-in method and enable:
- ✅ Email/Password
- ✅ Google
- ✅ Anonymous

For Google Sign-In:
1. Click on Google provider
2. Enable it
3. Add your project's OAuth 2.0 Client ID
4. Add authorized domains (localhost, your production domain)

### 4. (Optional) Seed Education Content

You can manually add education content in Firebase Console → Firestore Database:

**Collection:** `educationContent`

**Document ID:** `phishing`
```json
{
  "title": "Phishing Emails",
  "description": "Phishing is a fraudulent attempt to obtain sensitive information by disguising as a trustworthy entity.",
  "warningSigns": [
    "Urgent or threatening language",
    "Suspicious sender email address",
    "Generic greetings (Dear Customer)",
    "Requests for personal information",
    "Spelling and grammar errors"
  ],
  "preventionTips": [
    "Verify sender email address carefully",
    "Don't click suspicious links",
    "Check URL before entering credentials",
    "Enable two-factor authentication",
    "Report suspicious emails"
  ],
  "example": "Example: An email claiming to be from your bank asking you to verify your account by clicking a link."
}
```

Repeat for other scam types: `romance`, `payment`, `job`, `tech_support`

### 5. Run the Application

#### For Web (Chrome):
```bash
flutter run -d chrome
```

#### For Windows:
```bash
flutter run -d windows
```

#### For Android/iOS:
```bash
flutter run
```

---

## Testing the Integration

### Test 1: Anonymous User
1. Open the app
2. Click "Get Started" or "Continue as Guest"
3. Try analyzing some content (text, URL, or screenshot)
4. Verify you can do up to 3 analyses
5. On the 4th attempt, you should see a limit message

### Test 2: Email/Password Sign Up
1. Click "Sign In" → "Sign Up"
2. Enter name, email, and password
3. Click "Create Account"
4. Verify you're redirected to dashboard
5. Try analyzing content
6. Verify analysis is saved to your account

### Test 3: Google Sign-In
1. Click "Sign In"
2. Click "Continue with Google"
3. Select your Google account
4. Verify you're signed in
5. Try analyzing content

### Test 4: Analysis History
1. Sign in with your account
2. Perform multiple analyses
3. Navigate to Dashboard
4. Verify your analysis history is displayed

### Test 5: Community Features
1. Sign in
2. Navigate to Community
3. Create a post
4. Upvote/downvote posts
5. Filter by scam type

---

## Troubleshooting

### Issue: "Firebase not initialized"
**Solution:** Make sure `firebase_options.dart` exists and contains valid configuration.

### Issue: "Google Sign-In failed"
**Solution:** 
1. Check that Google provider is enabled in Firebase Console
2. Verify OAuth 2.0 Client ID is configured
3. Add authorized domains in Firebase Console

### Issue: "Permission denied" when accessing Firestore
**Solution:** 
1. Check that security rules are properly configured
2. Verify user is authenticated before making requests
3. Check that userId matches in security rules

### Issue: "Failed to upload screenshot"
**Solution:**
1. Check Storage rules are configured
2. Verify file size is under 10MB
3. Check Firebase Storage is enabled in your project

### Issue: Gemini API errors
**Solution:**
1. Verify API key is correct in `env_config.dart`
2. Check API quota limits in Google AI Studio
3. Ensure you're using the correct model name

---

## Project Structure

```
askbeforeact/
├── lib/
│   ├── core/                    # Core utilities and configuration
│   │   ├── config/
│   │   │   └── env_config.dart  # API keys and environment config
│   │   ├── constants/           # App constants
│   │   ├── theme/              # App theme
│   │   └── utils/              # Utility functions
│   │
│   ├── models/                  # Data models
│   │   ├── user_model.dart
│   │   ├── analysis_model.dart
│   │   ├── community_post_model.dart
│   │   └── education_content_model.dart
│   │
│   ├── services/               # External service integrations
│   │   ├── auth_service.dart        # Firebase Authentication
│   │   ├── firestore_service.dart   # Cloud Firestore
│   │   ├── storage_service.dart     # Firebase Storage
│   │   └── gemini_service.dart      # Google Gemini AI
│   │
│   ├── repositories/           # Business logic layer
│   │   ├── user_repository.dart
│   │   ├── analysis_repository.dart
│   │   └── community_repository.dart
│   │
│   ├── providers/              # State management
│   │   ├── auth_provider.dart
│   │   ├── analysis_provider.dart
│   │   └── community_provider.dart
│   │
│   ├── views/                  # UI screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home/
│   │   │   ├── landing_screen.dart
│   │   │   └── dashboard_screen.dart
│   │   ├── analysis/
│   │   │   ├── analyze_screen.dart
│   │   │   └── results_screen.dart
│   │   ├── community/
│   │   │   └── community_screen.dart
│   │   ├── education/
│   │   │   └── education_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   │
│   ├── widgets/                # Reusable widgets
│   │   └── common/
│   │       └── custom_button.dart
│   │
│   ├── firebase_options.dart   # Firebase configuration
│   └── main.dart              # App entry point
│
├── pubspec.yaml               # Dependencies
└── README.md                  # Project documentation
```

---

## Environment Variables

### Current Configuration
The app currently uses hardcoded API keys in `lib/core/config/env_config.dart`:
- Gemini API Key
- Firebase configuration (in `firebase_options.dart`)

### For Production
Consider using environment variables:
1. Create `.env` file (add to `.gitignore`)
2. Use `flutter_dotenv` package
3. Load secrets at runtime

---

## Deployment

### Deploy to Firebase Hosting
```bash
# Build web app
flutter build web

# Install Firebase CLI (if not installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase Hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
```

### Deploy to Vercel
```bash
# Build web app
flutter build web

# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod
```

---

## Next Steps

1. ✅ **Test thoroughly** - Try all features with different user types
2. ✅ **Configure security rules** - Protect your data
3. ✅ **Seed education content** - Add fraud prevention guides
4. ✅ **Enable authentication methods** - Email, Google, Anonymous
5. ⏳ **Add more features** - Implement remaining screens (Dashboard, Community, Education)
6. ⏳ **Improve UI/UX** - Polish the user interface
7. ⏳ **Add analytics** - Track user behavior
8. ⏳ **Deploy to production** - Make it live!

---

## Support

For issues or questions:
1. Check Firebase Console logs
2. Check Flutter console output
3. Review `INTEGRATION_COMPLETE.md` for architecture details
4. Check Firestore/Storage rules

---

**Happy coding! 🎉**
