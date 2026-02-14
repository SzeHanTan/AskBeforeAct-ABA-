# Firebase Setup Guide for AskBeforeAct
## Complete Backend Configuration

**Project ID:** `askbeforeact-f5326`  
**Last Updated:** February 14, 2026

---

## Table of Contents

1. [Firebase Authentication Setup](#1-firebase-authentication-setup)
2. [Cloud Firestore Setup](#2-cloud-firestore-setup)
3. [Firebase Storage Setup](#3-firebase-storage-setup)
4. [Firebase Hosting Setup](#4-firebase-hosting-setup)
5. [Security Rules Configuration](#5-security-rules-configuration)
6. [Testing Your Setup](#6-testing-your-setup)
7. [Getting Firebase Configuration](#7-getting-firebase-configuration)

---

## 1. Firebase Authentication Setup

### Step 1.1: Enable Authentication

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `askbeforeact-f5326`
3. In the left sidebar, click **"Authentication"**
4. Click **"Get started"** button

### Step 1.2: Enable Email/Password Authentication

1. Click on the **"Sign-in method"** tab
2. Click on **"Email/Password"** provider
3. Toggle **"Enable"** to ON
4. **Leave "Email link (passwordless sign-in)" disabled** for MVP
5. Click **"Save"**

### Step 1.3: Enable Google Sign-In

1. Still in the **"Sign-in method"** tab
2. Click on **"Google"** provider
3. Toggle **"Enable"** to ON
4. Enter your **Project support email** (your email address)
5. Click **"Save"**

### Step 1.4: Enable Anonymous Authentication

1. Still in the **"Sign-in method"** tab
2. Click on **"Anonymous"** provider
3. Toggle **"Enable"** to ON
4. Click **"Save"**

### Step 1.5: Configure Authorized Domains

1. Click on the **"Settings"** tab (gear icon)
2. Scroll to **"Authorized domains"**
3. By default, `localhost` and your Firebase domain are authorized
4. When you deploy to Vercel, add your Vercel domain:
   - Click **"Add domain"**
   - Enter your Vercel domain (e.g., `askbeforeact.vercel.app`)
   - Click **"Add"**

✅ **Authentication Setup Complete!**

---

## 2. Cloud Firestore Setup

### Step 2.1: Create Firestore Database

1. In the left sidebar, click **"Firestore Database"**
2. Click **"Create database"** button
3. Choose **"Start in production mode"** (we'll add rules next)
4. Click **"Next"**

### Step 2.2: Select Database Location

1. Choose a location closest to your target users:
   - **US:** `us-central1` (Iowa)
   - **Europe:** `europe-west1` (Belgium)
   - **Asia:** `asia-southeast1` (Singapore)
2. **IMPORTANT:** This cannot be changed later!
3. Click **"Enable"**

### Step 2.3: Create Collections Structure

Once the database is created, you'll see an empty database. We'll create the collections through code, but you can manually create the initial structure:

#### Create `users` Collection:
1. Click **"Start collection"**
2. Collection ID: `users`
3. Click **"Next"**
4. For the first document (just for testing):
   - Document ID: Click **"Auto-ID"**
   - Add fields:
     - `email` (string): `test@example.com`
     - `displayName` (string): `Test User`
     - `createdAt` (timestamp): Click "Set to current time"
     - `analysisCount` (number): `0`
     - `isAnonymous` (boolean): `false`
5. Click **"Save"**

#### Create `analyses` Collection:
1. Click **"Start collection"**
2. Collection ID: `analyses`
3. Click **"Next"**
4. For the first document:
   - Document ID: Click **"Auto-ID"**
   - Add fields:
     - `userId` (string): `test-user-id`
     - `type` (string): `text`
     - `content` (string): `Test analysis`
     - `riskScore` (number): `0`
     - `riskLevel` (string): `low`
     - `scamType` (string): `other`
     - `redFlags` (array): Leave empty `[]`
     - `recommendations` (array): Leave empty `[]`
     - `confidence` (string): `high`
     - `createdAt` (timestamp): Click "Set to current time"
5. Click **"Save"**

#### Create `communityPosts` Collection:
1. Click **"Start collection"**
2. Collection ID: `communityPosts`
3. Click **"Next"**
4. For the first document:
   - Document ID: Click **"Auto-ID"**
   - Add fields:
     - `userId` (string): `test-user-id`
     - `userName` (string): `Test User`
     - `isAnonymous` (boolean): `false`
     - `scamType` (string): `phishing`
     - `content` (string): `This is a test community post.`
     - `upvotes` (number): `0`
     - `downvotes` (number): `0`
     - `netVotes` (number): `0`
     - `voters` (map): Leave empty `{}`
     - `reported` (boolean): `false`
     - `reportCount` (number): `0`
     - `createdAt` (timestamp): Click "Set to current time"
5. Click **"Save"**

#### Create `educationContent` Collection:
1. Click **"Start collection"**
2. Collection ID: `educationContent`
3. Click **"Next"**
4. For the first document (Phishing guide):
   - Document ID: `phishing` (manual ID)
   - Add fields:
     - `id` (string): `phishing`
     - `title` (string): `Phishing Emails`
     - `description` (string): `Fraudulent emails designed to steal personal information`
     - `icon` (string): `🎣`
     - `warningSigns` (array): 
       - Add items: `Urgent language`, `Suspicious sender`, `Generic greetings`
     - `preventionTips` (array):
       - Add items: `Verify sender`, `Don't click links`, `Check URL carefully`
     - `example` (string): `"Your account will be closed unless you verify immediately"`
     - `order` (number): `1`
5. Click **"Save"**

**Repeat for other scam types:**
- `romance` (Romance Scams) - order: 2
- `payment` (Payment Fraud) - order: 3
- `job` (Job Scams) - order: 4
- `tech_support` (Tech Support Scams) - order: 5

### Step 2.4: Create Indexes (Optional for MVP)

Firestore will automatically suggest indexes when needed. For now, skip this step.

✅ **Firestore Setup Complete!**

---

## 3. Firebase Storage Setup

### Step 3.1: Create Storage Bucket

1. In the left sidebar, click **"Storage"**
2. Click **"Get started"** button
3. You'll see a dialog about security rules
4. Click **"Next"** (accept default production mode)
5. Choose the **same location** as your Firestore database
6. Click **"Done"**

### Step 3.2: Create Folder Structure

1. Click **"Create folder"**
2. Folder name: `screenshots`
3. Click **"Create folder"**

Inside `screenshots`, the app will automatically create user-specific folders like:
```
screenshots/
  ├── {userId1}/
  │   ├── {analysisId1}.jpg
  │   └── {analysisId2}.jpg
  └── {userId2}/
      └── {analysisId3}.jpg
```

✅ **Storage Setup Complete!**

---

## 4. Firebase Hosting Setup

### Step 4.1: Enable Firebase Hosting

1. In the left sidebar, click **"Hosting"**
2. Click **"Get started"** button
3. You'll see installation instructions for Firebase CLI

### Step 4.2: Install Firebase CLI (on your computer)

Open your terminal/PowerShell and run:

```powershell
npm install -g firebase-tools
```

### Step 4.3: Login to Firebase

```powershell
firebase login
```

This will open a browser window. Log in with your Google account.

### Step 4.4: Initialize Firebase Hosting (in your project folder)

Navigate to your project directory:

```powershell
cd C:\Users\tzeha\Desktop\AskBeforeAct-ABA-
```

Initialize Firebase:

```powershell
firebase init hosting
```

Answer the prompts:
1. **"Please select an option"**: Choose **"Use an existing project"**
2. **"Select a default Firebase project"**: Choose `askbeforeact-f5326`
3. **"What do you want to use as your public directory?"**: Enter `build/web`
4. **"Configure as a single-page app?"**: Enter `y` (yes)
5. **"Set up automatic builds and deploys with GitHub?"**: Enter `n` (no, for now)

This creates:
- `firebase.json` - Firebase configuration
- `.firebaserc` - Project aliases

### Step 4.5: Update firebase.json

The generated `firebase.json` should look like this:

```json
{
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
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  }
}
```

✅ **Hosting Setup Complete!**

---

## 5. Security Rules Configuration

### Step 5.1: Create Firestore Security Rules

Create a file named `firestore.rules` in your project root:

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
    
    function isValidUser(data) {
      return data.keys().hasAll(['id', 'email', 'displayName', 'createdAt', 'analysisCount', 'isAnonymous'])
        && data.id is string
        && data.email is string
        && data.displayName is string
        && data.createdAt is timestamp
        && data.analysisCount is int
        && data.isAnonymous is bool;
    }
    
    function isValidAnalysis(data) {
      return data.keys().hasAll(['userId', 'type', 'content', 'riskScore', 'riskLevel', 'scamType', 'redFlags', 'recommendations', 'confidence', 'createdAt'])
        && data.userId is string
        && data.type in ['screenshot', 'text', 'url']
        && data.riskScore is int
        && data.riskScore >= 0
        && data.riskScore <= 100
        && data.riskLevel in ['low', 'medium', 'high']
        && data.redFlags is list
        && data.recommendations is list;
    }
    
    function isValidPost(data) {
      return data.keys().hasAll(['userId', 'userName', 'isAnonymous', 'scamType', 'content', 'createdAt'])
        && data.content is string
        && data.content.size() <= 500
        && data.scamType in ['phishing', 'romance', 'payment', 'job', 'tech_support', 'other'];
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() 
        && request.auth.uid == userId
        && isValidUser(request.resource.data);
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Analyses collection
    match /analyses/{analysisId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow create: if isSignedIn() 
        && request.resource.data.userId == request.auth.uid
        && isValidAnalysis(request.resource.data);
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Community posts
    match /communityPosts/{postId} {
      allow read: if true; // Public read
      allow create: if isSignedIn() 
        && request.resource.data.userId == request.auth.uid
        && isValidPost(request.resource.data);
      allow update: if isSignedIn(); // For voting
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Education content (read-only)
    match /educationContent/{docId} {
      allow read: if true;
      allow write: if false; // Admin only via console
    }
  }
}
```

### Step 5.2: Create Storage Security Rules

Create a file named `storage.rules` in your project root:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    function isValidImage() {
      return request.resource.size < 5 * 1024 * 1024 // 5MB
        && request.resource.contentType.matches('image/.*');
    }
    
    // Screenshots
    match /screenshots/{userId}/{analysisId} {
      allow read: if isOwner(userId);
      allow write: if isOwner(userId) && isValidImage();
      allow delete: if isOwner(userId);
    }
  }
}
```

### Step 5.3: Deploy Security Rules

Deploy the rules to Firebase:

```powershell
firebase deploy --only firestore:rules,storage:rules
```

You should see:
```
✔  Deploy complete!
```

✅ **Security Rules Deployed!**

---

## 6. Testing Your Setup

### Step 6.1: Verify Authentication

1. Go to Firebase Console → Authentication
2. You should see:
   - ✅ Email/Password enabled
   - ✅ Google enabled
   - ✅ Anonymous enabled

### Step 6.2: Verify Firestore

1. Go to Firebase Console → Firestore Database
2. You should see collections:
   - ✅ `users`
   - ✅ `analyses`
   - ✅ `communityPosts`
   - ✅ `educationContent`

### Step 6.3: Verify Storage

1. Go to Firebase Console → Storage
2. You should see:
   - ✅ `screenshots/` folder

### Step 6.4: Test Security Rules

In Firestore, click on the **"Rules"** tab:
1. Click **"Rules Playground"** (if available)
2. Test a read operation:
   - Collection: `educationContent`
   - Document: `phishing`
   - Operation: `get`
   - Authenticated: No
   - **Result should be:** ✅ Allowed

---

## 7. Getting Firebase Configuration

### Step 7.1: Get Web App Configuration

1. Go to Firebase Console → Project Settings (gear icon)
2. Scroll down to **"Your apps"**
3. Click **"Add app"** → Select **Web** (</> icon)
4. Enter app nickname: `AskBeforeAct Web`
5. **Check** "Also set up Firebase Hosting"
6. Click **"Register app"**

### Step 7.2: Copy Configuration

You'll see something like this:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "askbeforeact-f5326.firebaseapp.com",
  projectId: "askbeforeact-f5326",
  storageBucket: "askbeforeact-f5326.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef123456"
};
```

### Step 7.3: Generate FlutterFire Configuration

Install FlutterFire CLI:

```powershell
dart pub global activate flutterfire_cli
```

Configure Firebase for Flutter:

```powershell
flutterfire configure --project=askbeforeact-f5326
```

This will:
1. Detect your Flutter project
2. Generate `firebase_options.dart` file
3. Configure for web platform

### Step 7.4: Verify firebase_options.dart

Check that `lib/firebase_options.dart` was created with your configuration.

✅ **Configuration Complete!**

---

## 8. Environment Variables (Optional)

For the Gemini API key, create a `.env` file in your project root:

```
GEMINI_API_KEY=your_gemini_api_key_here
```

**IMPORTANT:** Add `.env` to your `.gitignore`:

```
# .gitignore
.env
```

---

## 9. Quick Reference Commands

### Deploy Everything:
```powershell
firebase deploy
```

### Deploy Only Firestore Rules:
```powershell
firebase deploy --only firestore:rules
```

### Deploy Only Storage Rules:
```powershell
firebase deploy --only storage:rules
```

### Deploy Only Hosting:
```powershell
firebase deploy --only hosting
```

### View Logs:
```powershell
firebase functions:log
```

---

## 10. Troubleshooting

### Issue: "Permission denied" errors

**Solution:** Check that security rules are deployed:
```powershell
firebase deploy --only firestore:rules,storage:rules
```

### Issue: "Firebase not initialized"

**Solution:** Make sure `Firebase.initializeApp()` is called in `main.dart`:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Issue: "Invalid API key"

**Solution:** 
1. Regenerate `firebase_options.dart`:
   ```powershell
   flutterfire configure --project=askbeforeact-f5326
   ```
2. Restart your app

### Issue: Storage upload fails

**Solution:** 
1. Check file size (must be < 5MB)
2. Check file type (must be image/*)
3. Verify storage rules are deployed

---

## 11. Next Steps

Now that Firebase is set up, you can:

1. ✅ Start building your Flutter app
2. ✅ Implement authentication service
3. ✅ Create Firestore service layer
4. ✅ Build storage service for screenshots
5. ✅ Integrate Gemini AI API

Refer to `05_BACKEND_STRUCTURE.md` for the complete code implementation.

---

## 12. Important Notes

⚠️ **Security:**
- Never commit `firebase_options.dart` with real credentials to public repos
- Keep your Gemini API key in environment variables
- Use Firebase App Check in production

⚠️ **Free Tier Limits:**
- Firestore: 50K reads, 20K writes/day
- Storage: 5GB storage, 1GB/day downloads
- Authentication: Unlimited

⚠️ **Monitoring:**
- Check Firebase Console → Usage tab regularly
- Set up budget alerts in Firebase Console

---

**Setup Status:** ✅ Ready for Development  
**Last Updated:** February 14, 2026
