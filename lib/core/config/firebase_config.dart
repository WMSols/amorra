import 'package:amorra/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase Configuration
/// Handles Firebase initialization and setup
class FirebaseConfig {
  /// Initialize Firebase
  /// Call this in main.dart before runApp()
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(options: _getFirebaseOptions());
      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase initialization error: $e');
      }
      // Don't rethrow - allow app to continue for development
    }
  }

  /// Get Firebase options based on platform
  /// Uses auto-generated options from flutterfire configure
  static FirebaseOptions? _getFirebaseOptions() {
    try {
      return DefaultFirebaseOptions.currentPlatform;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase options error: $e');
      }
      return null;
    }
  }
}
