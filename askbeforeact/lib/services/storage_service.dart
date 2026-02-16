import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/// Firebase Storage Service for file uploads
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Upload screenshot/image and return download URL
  Future<String> uploadScreenshot({
    required Uint8List imageBytes,
    required String userId,
  }) async {
    try {
      // Generate unique filename
      final fileName = '${_uuid.v4()}.jpg';
      final path = 'screenshots/$userId/$fileName';

      // Create reference
      final ref = _storage.ref().child(path);

      // Upload file
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload screenshot: $e');
    }
  }

  /// Upload any file and return download URL
  Future<String> uploadFile({
    required Uint8List fileBytes,
    required String userId,
    required String fileName,
    String? contentType,
  }) async {
    try {
      // Generate unique filename
      final uniqueFileName = '${_uuid.v4()}_$fileName';
      final path = 'uploads/$userId/$uniqueFileName';

      // Create reference
      final ref = _storage.ref().child(path);

      // Upload file
      final uploadTask = ref.putData(
        fileBytes,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {
            'userId': userId,
            'originalFileName': fileName,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Delete file by URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Delete all user files
  Future<void> deleteUserFiles(String userId) async {
    try {
      // Delete screenshots
      final screenshotsRef = _storage.ref().child('screenshots/$userId');
      final screenshotsList = await screenshotsRef.listAll();
      
      for (final item in screenshotsList.items) {
        await item.delete();
      }

      // Delete uploads
      final uploadsRef = _storage.ref().child('uploads/$userId');
      final uploadsList = await uploadsRef.listAll();
      
      for (final item in uploadsList.items) {
        await item.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user files: $e');
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      return await ref.getMetadata();
    } catch (e) {
      throw Exception('Failed to get file metadata: $e');
    }
  }

  /// Get file size in bytes
  Future<int> getFileSize(String fileUrl) async {
    try {
      final metadata = await getFileMetadata(fileUrl);
      return metadata.size ?? 0;
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  /// List user's files
  Future<List<Reference>> listUserFiles(String userId) async {
    try {
      final List<Reference> allFiles = [];

      // List screenshots
      final screenshotsRef = _storage.ref().child('screenshots/$userId');
      final screenshotsList = await screenshotsRef.listAll();
      allFiles.addAll(screenshotsList.items);

      // List uploads
      final uploadsRef = _storage.ref().child('uploads/$userId');
      final uploadsList = await uploadsRef.listAll();
      allFiles.addAll(uploadsList.items);

      return allFiles;
    } catch (e) {
      throw Exception('Failed to list user files: $e');
    }
  }

  /// Get total storage used by user (in bytes)
  Future<int> getUserStorageUsage(String userId) async {
    try {
      final files = await listUserFiles(userId);
      int totalSize = 0;

      for (final file in files) {
        final metadata = await file.getMetadata();
        totalSize += metadata.size ?? 0;
      }

      return totalSize;
    } catch (e) {
      throw Exception('Failed to get user storage usage: $e');
    }
  }

  /// Format bytes to human-readable format
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
