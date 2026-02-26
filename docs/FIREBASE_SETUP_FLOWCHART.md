# Firebase Setup Flowchart
## Visual Guide for AskBeforeAct Backend Setup

---

## 🗺️ Complete Setup Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    START HERE                               │
│         Firebase Project: askbeforeact-f5326                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 1: Firebase Console Setup (Web Browser)               │
│  ────────────────────────────────────────                   │
│  Go to: https://console.firebase.google.com/                │
│  Select: askbeforeact-f5326                                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
        ┌───────────────────┴───────────────────┐
        ↓                                       ↓
┌──────────────────┐                  ┌──────────────────┐
│  Authentication  │                  │   Firestore DB   │
│  (5 minutes)     │                  │   (10 minutes)   │
├──────────────────┤                  ├──────────────────┤
│ ✓ Email/Password │                  │ ✓ Create DB      │
│ ✓ Google OAuth   │                  │ ✓ Choose location│
│ ✓ Anonymous      │                  │ ✓ 4 collections  │
└──────────────────┘                  │ ✓ Seed data      │
        ↓                              └──────────────────┘
        │                                       ↓
        │                              ┌──────────────────┐
        │                              │  Storage Setup   │
        │                              │  (3 minutes)     │
        │                              ├──────────────────┤
        │                              │ ✓ Enable Storage │
        │                              │ ✓ Same location  │
        │                              │ ✓ Create folder  │
        │                              └──────────────────┘
        │                                       ↓
        └───────────────────┬───────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 2: Local Development Setup (PowerShell)               │
│  ────────────────────────────────────────────               │
│  Location: C:\Users\tzeha\Desktop\AskBeforeAct-ABA-        │
└─────────────────────────────────────────────────────────────┘
                            ↓
        ┌───────────────────┴───────────────────┐
        ↓                                       ↓
┌──────────────────┐                  ┌──────────────────┐
│  Install Tools   │                  │  Firebase Init   │
│  (5 minutes)     │                  │  (5 minutes)     │
├──────────────────┤                  ├──────────────────┤
│ $ npm install -g │                  │ $ firebase login │
│   firebase-tools │                  │ $ firebase init  │
│                  │                  │   hosting        │
│ $ dart pub       │                  │                  │
│   global activate│                  │ Creates:         │
│   flutterfire_cli│                  │ • firebase.json  │
└──────────────────┘                  │ • .firebaserc    │
        ↓                              └──────────────────┘
        │                                       ↓
        └───────────────────┬───────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 3: Deploy Security Rules (PowerShell)                 │
│  ────────────────────────────────────────                   │
│  $ firebase deploy --only firestore:rules,storage:rules     │
│                                                              │
│  Files deployed:                                             │
│  ✓ firestore.rules                                          │
│  ✓ storage.rules                                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 4: Generate Flutter Configuration (PowerShell)        │
│  ────────────────────────────────────────────               │
│  $ flutterfire configure --project=askbeforeact-f5326       │
│                                                              │
│  Creates: lib/firebase_options.dart                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 5: Add Gemini API Key                                 │
│  ────────────────────────────────────────────               │
│  1. Get key: https://makersuite.google.com/app/apikey      │
│  2. Create .env file:                                       │
│     GEMINI_API_KEY=your_key_here                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  STEP 6: Verify Setup (Firebase Console)                    │
│  ────────────────────────────────────────────               │
│  ✓ Authentication: 3 providers enabled                      │
│  ✓ Firestore: 4 collections with data                      │
│  ✓ Storage: screenshots/ folder exists                      │
│  ✓ Rules: Deployed and active                               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    ✅ SETUP COMPLETE!                       │
│              Ready to start Flutter development             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Service Dependencies

```
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Services                        │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Authentication│    │  Firestore   │    │   Storage    │
└──────────────┘    └──────────────┘    └──────────────┘
        │                   │                   │
        │                   │                   │
        └───────────────────┼───────────────────┘
                            ↓
                    ┌──────────────┐
                    │ Security     │
                    │ Rules        │
                    └──────────────┘
                            ↓
                    ┌──────────────┐
                    │ Flutter App  │
                    └──────────────┘
                            ↓
                    ┌──────────────┐
                    │ Gemini AI    │
                    └──────────────┘
```

---

## 🗄️ Database Structure

```
Firestore Database
│
├── users/
│   └── {userId}/
│       ├── id: string
│       ├── email: string
│       ├── displayName: string
│       ├── createdAt: timestamp
│       ├── analysisCount: number
│       └── isAnonymous: boolean
│
├── analyses/
│   └── {analysisId}/
│       ├── userId: string
│       ├── type: "screenshot" | "text" | "url"
│       ├── content: string
│       ├── riskScore: number (0-100)
│       ├── riskLevel: "low" | "medium" | "high"
│       ├── scamType: string
│       ├── redFlags: array<string>
│       ├── recommendations: array<string>
│       ├── confidence: string
│       └── createdAt: timestamp
│
├── communityPosts/
│   └── {postId}/
│       ├── userId: string
│       ├── userName: string
│       ├── isAnonymous: boolean
│       ├── scamType: string
│       ├── content: string
│       ├── upvotes: number
│       ├── downvotes: number
│       ├── netVotes: number
│       ├── voters: map
│       ├── reported: boolean
│       ├── reportCount: number
│       └── createdAt: timestamp
│
└── educationContent/
    ├── phishing/
    ├── romance/
    ├── payment/
    ├── job/
    └── tech_support/
        ├── id: string
        ├── title: string
        ├── description: string
        ├── icon: string
        ├── warningSigns: array
        ├── preventionTips: array
        ├── example: string
        └── order: number
```

---

## 📁 Storage Structure

```
Firebase Storage
│
└── screenshots/
    ├── {userId1}/
    │   ├── {analysisId1}.jpg
    │   ├── {analysisId2}.jpg
    │   └── {analysisId3}.jpg
    │
    ├── {userId2}/
    │   ├── {analysisId4}.jpg
    │   └── {analysisId5}.jpg
    │
    └── {userId3}/
        └── {analysisId6}.jpg
```

---

## 🔐 Security Rules Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    User Request                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
                ┌───────────────────────┐
                │  Is user signed in?   │
                └───────────────────────┘
                    ↓           ↓
                   YES          NO
                    ↓           ↓
        ┌──────────────┐   ┌──────────────┐
        │ Check rules  │   │ Deny (except │
        │ for resource │   │ public reads)│
        └──────────────┘   └──────────────┘
                ↓
    ┌──────────────────────────┐
    │ Is user the owner?       │
    │ OR                       │
    │ Is resource public?      │
    └──────────────────────────┘
        ↓               ↓
       YES              NO
        ↓               ↓
    ┌────────┐      ┌────────┐
    │ Allow  │      │ Deny   │
    └────────┘      └────────┘
```

---

## 🔄 Data Flow: Screenshot Analysis

```
┌─────────────────────────────────────────────────────────────┐
│  1. User uploads screenshot                                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  2. Flutter app validates (size, type)                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  3. Upload to Firebase Storage                              │
│     Path: screenshots/{userId}/{analysisId}.jpg             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  4. Send to Gemini AI API                                   │
│     - Screenshot bytes                                       │
│     - Analysis prompt                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  5. Gemini returns JSON response                            │
│     - riskScore                                              │
│     - scamType                                               │
│     - redFlags                                               │
│     - recommendations                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  6. Save analysis to Firestore                              │
│     Collection: analyses                                     │
│     Document: auto-generated ID                              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  7. Update user stats                                        │
│     Increment: analysisCount                                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  8. Display results to user                                  │
│     - Risk score with color                                  │
│     - Red flags list                                         │
│     - Recommendations                                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow: Community Post

```
┌─────────────────────────────────────────────────────────────┐
│  1. User creates post                                        │
│     - Content (max 500 chars)                               │
│     - Scam type                                              │
│     - Anonymous option                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  2. Validate content                                         │
│     - Length check                                           │
│     - Profanity filter (optional)                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  3. Save to Firestore                                        │
│     Collection: communityPosts                               │
│     Initial values:                                          │
│     - upvotes: 0                                             │
│     - downvotes: 0                                           │
│     - reported: false                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  4. Post appears in community feed                           │
│     - Real-time updates                                      │
│     - Sorted by date or votes                                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  5. Users can vote                                           │
│     - Update upvotes/downvotes                              │
│     - Track voters to prevent duplicate votes               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📱 Authentication Flow

```
┌─────────────────────────────────────────────────────────────┐
│  User opens app                                              │
└─────────────────────────────────────────────────────────────┘
                            ↓
                ┌───────────────────────┐
                │  Is user logged in?   │
                └───────────────────────┘
                    ↓           ↓
                   YES          NO
                    ↓           ↓
        ┌──────────────┐   ┌──────────────┐
        │ Show home    │   │ Show login   │
        │ screen       │   │ screen       │
        └──────────────┘   └──────────────┘
                                ↓
                    ┌───────────────────────┐
                    │ Choose login method:  │
                    │ • Email/Password      │
                    │ • Google              │
                    │ • Anonymous           │
                    └───────────────────────┘
                                ↓
                    ┌───────────────────────┐
                    │ Firebase Auth         │
                    │ validates credentials │
                    └───────────────────────┘
                        ↓           ↓
                    Success       Failure
                        ↓           ↓
            ┌──────────────┐   ┌──────────────┐
            │ Create user  │   │ Show error   │
            │ profile in   │   │ message      │
            │ Firestore    │   └──────────────┘
            └──────────────┘
                    ↓
            ┌──────────────┐
            │ Show home    │
            │ screen       │
            └──────────────┘
```

---

## 🎯 Setup Progress Tracker

```
Setup Phase 1: Firebase Console (20 minutes)
├── [  ] Authentication enabled
│   ├── [  ] Email/Password
│   ├── [  ] Google OAuth
│   └── [  ] Anonymous
├── [  ] Firestore Database created
│   ├── [  ] Location selected
│   ├── [  ] users collection
│   ├── [  ] analyses collection
│   ├── [  ] communityPosts collection
│   └── [  ] educationContent collection (5 docs)
└── [  ] Storage enabled
    └── [  ] screenshots folder created

Setup Phase 2: Local Development (15 minutes)
├── [  ] Firebase CLI installed
├── [  ] FlutterFire CLI installed
├── [  ] Firebase login completed
├── [  ] Firebase hosting initialized
└── [  ] firebase.json created

Setup Phase 3: Configuration (10 minutes)
├── [  ] Security rules deployed
│   ├── [  ] firestore.rules
│   └── [  ] storage.rules
├── [  ] Flutter config generated
│   └── [  ] firebase_options.dart
└── [  ] Environment variables set
    └── [  ] .env with Gemini API key

Verification (5 minutes)
├── [  ] Authentication works
├── [  ] Firestore accessible
├── [  ] Storage accessible
└── [  ] Rules enforced

Total Time: ~50 minutes
```

---

## 📊 Cost Monitoring Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│  Firebase Free Tier Usage                                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Authentication                                              │
│  [████████████████████████████████] Unlimited                │
│                                                              │
│  Firestore Reads (per day)                                  │
│  [████░░░░░░░░░░░░░░░░░░░░░░░░░░] 1K / 50K                  │
│                                                              │
│  Firestore Writes (per day)                                 │
│  [██░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 500 / 20K                 │
│                                                              │
│  Storage (total)                                             │
│  [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 500MB / 5GB               │
│                                                              │
│  Storage Transfer (per day)                                  │
│  [█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 100MB / 1GB               │
│                                                              │
│  Gemini API (per minute)                                     │
│  [███░░░░░░░░░░░░░░░░░░░░░░░░░░░] 3 / 15 requests           │
│                                                              │
│  Status: ✅ All services within free tier                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎉 Success State

```
┌─────────────────────────────────────────────────────────────┐
│                    ✅ FIREBASE READY                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Services Enabled:                                           │
│  ✓ Authentication (3 providers)                             │
│  ✓ Firestore Database (4 collections)                       │
│  ✓ Storage (screenshots folder)                             │
│  ✓ Security Rules (deployed)                                │
│                                                              │
│  Configuration:                                              │
│  ✓ firebase_options.dart                                    │
│  ✓ .env with Gemini API key                                │
│  ✓ firebase.json                                            │
│                                                              │
│  Next: Start Flutter Development!                           │
│  See: 05_BACKEND_STRUCTURE.md                               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 📚 Quick Reference

### Firebase Console URLs
- **Main Console:** https://console.firebase.google.com/
- **Your Project:** https://console.firebase.google.com/project/askbeforeact-f5326
- **Authentication:** https://console.firebase.google.com/project/askbeforeact-f5326/authentication
- **Firestore:** https://console.firebase.google.com/project/askbeforeact-f5326/firestore
- **Storage:** https://console.firebase.google.com/project/askbeforeact-f5326/storage

### Key Commands
```bash
# Login
firebase login

# Initialize
firebase init hosting

# Deploy rules
firebase deploy --only firestore:rules,storage:rules

# Configure Flutter
flutterfire configure --project=askbeforeact-f5326

# Deploy everything
firebase deploy
```

---

**Last Updated:** February 14, 2026  
**Status:** Ready for Setup
