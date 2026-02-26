# AskBeforeAct (ABA) - Backend Structure
## Firebase Backend Architecture & Implementation

**Version:** 1.0  
**Last Updated:** February 13, 2026  

---

## Table of Contents

1. [Backend Overview](#1-backend-overview)
2. [Firebase Architecture](#2-firebase-architecture)
3. [Authentication System](#3-authentication-system)
4. [Database Design](#4-database-design)
5. [Storage Management](#5-storage-management)
6. [Security Rules](#6-security-rules)
7. [Data Models](#7-data-models)
8. [Service Layer](#8-service-layer)
9. [Repository Pattern](#9-repository-pattern)
10. [AI Integration](#10-ai-integration)

---

## 1. Backend Overview

### 1.1 Architecture Philosophy

AskBeforeAct uses a **serverless architecture** powered by Firebase, eliminating the need for traditional backend servers. All backend logic runs client-side in Flutter, with Firebase providing:

- **Authentication:** User management
- **Firestore:** NoSQL database
- **Storage:** File hosting
- **Security Rules:** Server-side validation

### 1.2 Benefits of Firebase Backend

✅ **Zero server maintenance**  
✅ **Automatic scaling**  
✅ **Real-time data sync**  
✅ **Built-in security**  
✅ **Free tier for MVP**  
✅ **Easy integration with Flutter**  

### 1.3 Backend Components

```
┌─────────────────────────────────────────────┐
│          Flutter App (Client)               │
│  ┌─────────────┐  ┌─────────────┐          │
│  │  Services   │  │ Repositories│          │
│  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│            Firebase Backend                 │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │   Auth   │ │ Firestore│ │ Storage  │   │
│  └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────┘
                    ↕
┌─────────────────────────────────────────────┐
│          External Services                  │
│           Gemini AI API                     │
└─────────────────────────────────────────────┘
```

---

## 2. Firebase Architecture

### 2.1 Project Structure

```
Firebase Project: askbeforeact-mvp
├── Authentication
│   ├── Email/Password
│   ├── Google OAuth
│   └── Anonymous
│
├── Firestore Database
│   ├── users/
│   ├── analyses/
│   ├── communityPosts/
│   └── educationContent/
│
├── Storage
│   └── screenshots/
│
└── Security Rules
    ├── Firestore Rules
    └── Storage Rules
```

### 2.2 Firebase Initialization

**lib/main.dart:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

---

## 3. Authentication System

### 3.1 Authentication Service

**lib/services/auth_service.dart:**

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Email/Password Sign In
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }
      
      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }
  
  // Anonymous Sign In
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
  
  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Delete Account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  // Handle Firebase Auth Exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
```

### 3.2 User Profile Management

**lib/services/user_service.dart:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Create user profile
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }
  
  // Get user profile
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    
    if (!doc.exists) return null;
    
    return UserModel.fromMap(doc.data()!);
  }
  
  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }
  
  // Increment analysis count
  Future<void> incrementAnalysisCount(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'analysisCount': FieldValue.increment(1),
    });
  }
  
  // Delete user profile
  Future<void> deleteUserProfile(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
```

---

## 4. Database Design

### 4.1 Firestore Collections

#### Collection: `users`

**Document ID:** `{userId}` (Firebase Auth UID)

**Fields:**
```dart
{
  'id': String,              // User ID (same as doc ID)
  'email': String,           // User email
  'displayName': String,     // Full name
  'createdAt': Timestamp,    // Account creation date
  'analysisCount': int,      // Total analyses performed
  'isAnonymous': bool,       // Is anonymous user
}
```

#### Collection: `analyses`

**Document ID:** Auto-generated

**Fields:**
```dart
{
  'id': String,                    // Analysis ID
  'userId': String,                // Owner user ID
  'type': String,                  // 'screenshot' | 'text' | 'url'
  'content': String,               // Storage URL or text content
  'riskScore': int,                // 0-100
  'riskLevel': String,             // 'low' | 'medium' | 'high'
  'scamType': String,              // 'phishing' | 'romance' | etc.
  'redFlags': List<String>,        // List of detected red flags
  'recommendations': List<String>, // List of recommendations
  'confidence': String,            // 'low' | 'medium' | 'high'
  'createdAt': Timestamp,          // Analysis timestamp
}
```

#### Collection: `communityPosts`

**Document ID:** Auto-generated

**Fields:**
```dart
{
  'id': String,              // Post ID
  'userId': String,          // Author user ID
  'userName': String,        // Author display name
  'isAnonymous': bool,       // Posted anonymously
  'scamType': String,        // Scam category
  'content': String,         // Post content (max 500 chars)
  'upvotes': int,            // Upvote count
  'downvotes': int,          // Downvote count
  'netVotes': int,           // upvotes - downvotes
  'voters': Map<String, String>, // {userId: 'up' | 'down'}
  'reported': bool,          // Has been reported
  'reportCount': int,        // Number of reports
  'createdAt': Timestamp,    // Post timestamp
}
```

#### Collection: `educationContent`

**Document ID:** `{scamTypeId}` (e.g., 'phishing', 'romance')

**Fields:**
```dart
{
  'id': String,                  // Scam type ID
  'title': String,               // Display title
  'description': String,         // Overview paragraph
  'icon': String,                // Emoji or icon name
  'warningSigns': List<String>,  // List of warning signs
  'preventionTips': List<String>, // List of prevention tips
  'example': String,             // Real example text
  'order': int,                  // Display order
}
```

### 4.2 Firestore Service

**lib/services/firestore_service.dart:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Generic CRUD operations
  
  // Create document
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final docRef = await _firestore.collection(collection).add(data);
    return docRef.id;
  }
  
  // Read document
  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String docId,
  ) async {
    final doc = await _firestore.collection(collection).doc(docId).get();
    return doc.exists ? doc.data() : null;
  }
  
  // Update document
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }
  
  // Delete document
  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }
  
  // Query documents
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    String? whereField,
    dynamic whereValue,
    String? orderByField,
    bool descending = false,
    int? limit,
  }) async {
    Query query = _firestore.collection(collection);
    
    if (whereField != null) {
      query = query.where(whereField, isEqualTo: whereValue);
    }
    
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
  
  // Stream documents (real-time)
  Stream<List<Map<String, dynamic>>> streamDocuments(
    String collection, {
    String? whereField,
    dynamic whereValue,
    String? orderByField,
    bool descending = false,
  }) {
    Query query = _firestore.collection(collection);
    
    if (whereField != null) {
      query = query.where(whereField, isEqualTo: whereValue);
    }
    
    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: descending);
    }
    
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList(),
    );
  }
}
```

---

## 5. Storage Management

### 5.1 Firebase Storage Service

**lib/services/storage_service.dart:**

```dart
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload screenshot
  Future<String> uploadScreenshot({
    required String userId,
    required String analysisId,
    required Uint8List fileBytes,
  }) async {
    try {
      // Create reference
      final ref = _storage.ref().child('screenshots/$userId/$analysisId.jpg');
      
      // Upload file
      final uploadTask = ref.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      // Wait for completion
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload screenshot: $e');
    }
  }
  
  // Delete screenshot
  Future<void> deleteScreenshot({
    required String userId,
    required String analysisId,
  }) async {
    try {
      final ref = _storage.ref().child('screenshots/$userId/$analysisId.jpg');
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete screenshot: $e');
    }
  }
  
  // Get download URL
  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }
  
  // Delete all user screenshots
  Future<void> deleteUserScreenshots(String userId) async {
    try {
      final ref = _storage.ref().child('screenshots/$userId');
      final listResult = await ref.listAll();
      
      // Delete all files
      await Future.wait(
        listResult.items.map((item) => item.delete()),
      );
    } catch (e) {
      throw Exception('Failed to delete user screenshots: $e');
    }
  }
}
```

---

## 6. Security Rules

### 6.1 Firestore Security Rules

**firestore.rules:**

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

### 6.2 Storage Security Rules

**storage.rules:**

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

---

## 7. Data Models

### 7.1 User Model

**lib/models/user_model.dart:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final int analysisCount;
  final bool isAnonymous;
  
  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.analysisCount = 0,
    this.isAnonymous = false,
  });
  
  // From Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      analysisCount: map['analysisCount'] as int? ?? 0,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
    );
  }
  
  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'analysisCount': analysisCount,
      'isAnonymous': isAnonymous,
    };
  }
  
  // Copy with
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    int? analysisCount,
    bool? isAnonymous,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      analysisCount: analysisCount ?? this.analysisCount,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
```

### 7.2 Analysis Model

**lib/models/analysis_model.dart:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalysisModel {
  final String id;
  final String userId;
  final String type; // 'screenshot' | 'text' | 'url'
  final String content;
  final int riskScore;
  final String riskLevel; // 'low' | 'medium' | 'high'
  final String scamType;
  final List<String> redFlags;
  final List<String> recommendations;
  final String confidence; // 'low' | 'medium' | 'high'
  final DateTime createdAt;
  
  AnalysisModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.riskScore,
    required this.riskLevel,
    required this.scamType,
    required this.redFlags,
    required this.recommendations,
    required this.confidence,
    required this.createdAt,
  });
  
  factory AnalysisModel.fromMap(Map<String, dynamic> map, String id) {
    return AnalysisModel(
      id: id,
      userId: map['userId'] as String,
      type: map['type'] as String,
      content: map['content'] as String,
      riskScore: map['riskScore'] as int,
      riskLevel: map['riskLevel'] as String,
      scamType: map['scamType'] as String,
      redFlags: List<String>.from(map['redFlags'] as List),
      recommendations: List<String>.from(map['recommendations'] as List),
      confidence: map['confidence'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'content': content,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'scamType': scamType,
      'redFlags': redFlags,
      'recommendations': recommendations,
      'confidence': confidence,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
```

### 7.3 Community Post Model

**lib/models/community_post_model.dart:**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  final String id;
  final String userId;
  final String userName;
  final bool isAnonymous;
  final String scamType;
  final String content;
  final int upvotes;
  final int downvotes;
  final int netVotes;
  final Map<String, String> voters; // {userId: 'up' | 'down'}
  final bool reported;
  final int reportCount;
  final DateTime createdAt;
  
  CommunityPostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.isAnonymous,
    required this.scamType,
    required this.content,
    this.upvotes = 0,
    this.downvotes = 0,
    this.netVotes = 0,
    this.voters = const {},
    this.reported = false,
    this.reportCount = 0,
    required this.createdAt,
  });
  
  factory CommunityPostModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityPostModel(
      id: id,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      isAnonymous: map['isAnonymous'] as bool,
      scamType: map['scamType'] as String,
      content: map['content'] as String,
      upvotes: map['upvotes'] as int? ?? 0,
      downvotes: map['downvotes'] as int? ?? 0,
      netVotes: map['netVotes'] as int? ?? 0,
      voters: Map<String, String>.from(map['voters'] as Map? ?? {}),
      reported: map['reported'] as bool? ?? false,
      reportCount: map['reportCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'isAnonymous': isAnonymous,
      'scamType': scamType,
      'content': content,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'netVotes': netVotes,
      'voters': voters,
      'reported': reported,
      'reportCount': reportCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
```

---

## 8. Service Layer

### 8.1 Analysis Service

**lib/services/analysis_service.dart:**

```dart
import '../models/analysis_model.dart';
import 'firestore_service.dart';
import 'storage_service.dart';
import 'ai_service.dart';

class AnalysisService {
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final AIService _aiService;
  
  AnalysisService(
    this._firestoreService,
    this._storageService,
    this._aiService,
  );
  
  // Analyze content
  Future<AnalysisModel> analyzeContent({
    required String userId,
    required String type,
    required dynamic content, // String or Uint8List
  }) async {
    String contentUrl = '';
    
    // Upload screenshot if needed
    if (type == 'screenshot') {
      final analysisId = DateTime.now().millisecondsSinceEpoch.toString();
      contentUrl = await _storageService.uploadScreenshot(
        userId: userId,
        analysisId: analysisId,
        fileBytes: content,
      );
    } else {
      contentUrl = content as String;
    }
    
    // Analyze with AI
    final aiResult = await _aiService.analyze(
      content: content,
      type: type,
    );
    
    // Create analysis model
    final analysis = AnalysisModel(
      id: '',
      userId: userId,
      type: type,
      content: contentUrl,
      riskScore: aiResult['riskScore'],
      riskLevel: aiResult['riskLevel'],
      scamType: aiResult['scamType'],
      redFlags: List<String>.from(aiResult['redFlags']),
      recommendations: List<String>.from(aiResult['recommendations']),
      confidence: aiResult['confidence'],
      createdAt: DateTime.now(),
    );
    
    // Save to Firestore
    final docId = await _firestoreService.createDocument(
      'analyses',
      analysis.toMap(),
    );
    
    return analysis.copyWith(id: docId);
  }
  
  // Get user analyses
  Future<List<AnalysisModel>> getUserAnalyses(String userId) async {
    final docs = await _firestoreService.queryDocuments(
      'analyses',
      whereField: 'userId',
      whereValue: userId,
      orderByField: 'createdAt',
      descending: true,
      limit: 30,
    );
    
    return docs.map((doc) => AnalysisModel.fromMap(doc, doc['id'])).toList();
  }
  
  // Delete analysis
  Future<void> deleteAnalysis(String analysisId, String userId) async {
    // Delete from Firestore
    await _firestoreService.deleteDocument('analyses', analysisId);
    
    // Delete screenshot if exists
    try {
      await _storageService.deleteScreenshot(
        userId: userId,
        analysisId: analysisId,
      );
    } catch (e) {
      // Screenshot might not exist (text/url analysis)
    }
  }
}
```

---

## 9. Repository Pattern

### 9.1 Analysis Repository

**lib/repositories/analysis_repository.dart:**

```dart
import '../models/analysis_model.dart';
import '../services/analysis_service.dart';

class AnalysisRepository {
  final AnalysisService _analysisService;
  
  AnalysisRepository(this._analysisService);
  
  Future<AnalysisModel> analyzeContent({
    required String userId,
    required String type,
    required dynamic content,
  }) async {
    return await _analysisService.analyzeContent(
      userId: userId,
      type: type,
      content: content,
    );
  }
  
  Future<List<AnalysisModel>> getUserAnalyses(String userId) async {
    return await _analysisService.getUserAnalyses(userId);
  }
  
  Future<void> deleteAnalysis(String analysisId, String userId) async {
    await _analysisService.deleteAnalysis(analysisId, userId);
  }
}
```

---

## 10. AI Integration

### 10.1 AI Service

**lib/services/ai_service.dart:**

```dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final String _apiKey;
  late final GenerativeModel _model;
  
  AIService(this._apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        maxOutputTokens: 2048,
      ),
    );
  }
  
  // Analyze content
  Future<Map<String, dynamic>> analyze({
    required dynamic content,
    required String type,
  }) async {
    try {
      final prompt = _buildPrompt(type);
      
      GenerateContentResponse response;
      
      if (type == 'screenshot' && content is Uint8List) {
        response = await _model.generateContent([
          Content.multi([
            TextPart(prompt),
            DataPart('image/jpeg', content),
          ])
        ]);
      } else {
        final fullPrompt = '$prompt\n\nContent: $content';
        response = await _model.generateContent([Content.text(fullPrompt)]);
      }
      
      final text = response.text!;
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      
      if (jsonMatch == null) {
        throw Exception('No JSON found in response');
      }
      
      final jsonStr = jsonMatch.group(0)!;
      final result = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      return result;
    } catch (e) {
      throw Exception('AI analysis failed: $e');
    }
  }
  
  String _buildPrompt(String type) {
    return '''
You are a fraud detection expert. Analyze the following content for potential fraud indicators.

Content Type: $type

Provide a JSON response with this exact structure:
{
  "riskScore": 0-100,
  "riskLevel": "low" | "medium" | "high",
  "scamType": "phishing" | "romance" | "payment" | "job" | "tech_support" | "other",
  "redFlags": ["specific indicator 1", "specific indicator 2", ...],
  "recommendations": ["action 1", "action 2", "action 3"],
  "confidence": "low" | "medium" | "high"
}

Risk Level Guidelines:
- low: 0-30% risk score
- medium: 31-70% risk score
- high: 71-100% risk score

Be specific and cite evidence from the content in your red flags.
Provide actionable, prioritized recommendations.
''';
  }
}
```

---

## Conclusion

This backend structure provides:

- **Serverless architecture** with Firebase
- **Secure authentication** with multiple providers
- **Scalable database** with Firestore
- **File storage** with Firebase Storage
- **Robust security** with Firebase Security Rules
- **Clean architecture** with services and repositories
- **AI integration** with Gemini API

All components work together to create a secure, scalable backend without traditional servers.

---

**Next Steps:**
1. Set up Firebase project
2. Implement services layer
3. Create repositories
4. Test security rules

**Document Version:** 1.0  
**Status:** Ready for Development
