import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

/// Repository for user operations
class UserRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  final StorageService _storageService;

  UserRepository({
    required AuthService authService,
    required FirestoreService firestoreService,
    required StorageService storageService,
  })  : _authService = authService,
        _firestoreService = firestoreService,
        _storageService = storageService;

  // ==================== AUTHENTICATION ====================

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Create user document in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        analysisCount: 0,
        isAnonymous: false,
      );

      await _firestoreService.createOrUpdateUser(user);

      return user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      // Get or create user document
      final userId = userCredential.user!.uid;
      UserModel? user = await _firestoreService.getUserById(userId);

      if (user == null) {
        // Create user document if it doesn't exist
        user = UserModel(
          id: userId,
          email: email,
          displayName: userCredential.user!.displayName ?? 'User',
          createdAt: DateTime.now(),
          analysisCount: 0,
          isAnonymous: false,
        );
        await _firestoreService.createOrUpdateUser(user);
      }

      return user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _authService.signInWithGoogle();

      // Get or create user document
      final userId = userCredential.user!.uid;
      UserModel? user = await _firestoreService.getUserById(userId);

      if (user == null) {
        // Create user document if it doesn't exist
        user = UserModel(
          id: userId,
          email: userCredential.user!.email ?? '',
          displayName: userCredential.user!.displayName ?? 'User',
          createdAt: DateTime.now(),
          analysisCount: 0,
          isAnonymous: false,
        );
        await _firestoreService.createOrUpdateUser(user);
      }

      return user;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  /// Sign in anonymously
  Future<UserModel> signInAnonymously() async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _authService.signInAnonymously();

      // Create anonymous user document
      final user = UserModel(
        id: userCredential.user!.uid,
        email: '',
        displayName: 'Anonymous User',
        createdAt: DateTime.now(),
        analysisCount: 0,
        isAnonymous: true,
      );

      await _firestoreService.createOrUpdateUser(user);

      return user;
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // ==================== USER DATA ====================

  /// Get current user
  User? getCurrentFirebaseUser() {
    return _authService.currentUser;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _authService.currentUserId;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _authService.isAuthenticated;
  }

  /// Check if user is anonymous
  bool isAnonymous() {
    return _authService.isAnonymous;
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _firestoreService.getUserById(userId);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Get current user model
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) return null;
      return await getUserById(userId);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      // Update Firebase Auth
      await _authService.updateDisplayName(displayName);

      // Update Firestore
      final user = await getUserById(userId);
      if (user != null) {
        final updatedUser = user.copyWith(displayName: displayName);
        await _firestoreService.createOrUpdateUser(updatedUser);
      }
    } catch (e) {
      throw Exception('Failed to update display name: $e');
    }
  }

  /// Update user email
  Future<void> updateEmail(String email) async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      // Update Firebase Auth
      await _authService.updateEmail(email);

      // Update Firestore
      final user = await getUserById(userId);
      if (user != null) {
        final updatedUser = user.copyWith(email: email);
        await _firestoreService.createOrUpdateUser(updatedUser);
      }
    } catch (e) {
      throw Exception('Failed to update email: $e');
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _authService.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      // Delete user files from Storage
      await _storageService.deleteUserFiles(userId);

      // Delete Firebase Auth user (Firestore data will be handled by security rules)
      await _authService.deleteAccount();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  // ==================== USER STATISTICS ====================

  /// Get user's analysis count
  Future<int> getUserAnalysisCount(String userId) async {
    try {
      return await _firestoreService.getUserAnalysisCount(userId);
    } catch (e) {
      throw Exception('Failed to get analysis count: $e');
    }
  }

  /// Get user's high-risk analyses count
  Future<int> getUserHighRiskCount(String userId) async {
    try {
      return await _firestoreService.getUserHighRiskCount(userId);
    } catch (e) {
      throw Exception('Failed to get high-risk count: $e');
    }
  }

  /// Get user storage usage
  Future<int> getUserStorageUsage(String userId) async {
    try {
      return await _storageService.getUserStorageUsage(userId);
    } catch (e) {
      throw Exception('Failed to get storage usage: $e');
    }
  }

  /// Format storage size
  String formatStorageSize(int bytes) {
    return _storageService.formatBytes(bytes);
  }

  // ==================== AUTH STATE ====================

  /// Listen to auth state changes
  Stream<User?> authStateChanges() {
    return _authService.authStateChanges;
  }
}
