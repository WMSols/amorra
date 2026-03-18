import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amorra/data/services/firebase_service.dart';
import 'package:flutter/foundation.dart';

/// Admin Auth Service
/// Handles admin authentication and authorization
class AdminAuthService {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Collection name for admin users
  static const String adminCollection = 'admins';

  /// Check if current user is admin
  /// Checks both Firebase Auth custom claims and Firestore admin collection
  Future<bool> isAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Check custom claims first (faster)
      try {
        final idTokenResult = await user.getIdTokenResult();
        if (idTokenResult.claims?['admin'] == true) {
          return true;
        }
      } catch (e) {
        // If getting token fails, user might be signed out
        if (kDebugMode) {
          print('Error getting ID token: $e');
        }
        return false;
      }

      // Fallback: Check Firestore admin collection
      // Only check if user is still authenticated
      if (_auth.currentUser == null) return false;

      try {
        final adminDoc = await _firestore
            .collection(adminCollection)
            .doc(user.uid)
            .get();
        return adminDoc.exists && (adminDoc.data()?['isAdmin'] == true);
      } catch (e) {
        // If Firestore check fails (e.g., permission denied), return false
        if (kDebugMode) {
          print('Error checking Firestore admin collection: $e');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking admin status: $e');
      }
      return false;
    }
  }

  /// Sign in admin with email and password
  Future<UserCredential> signInAdmin(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify admin status
      final isAdminUser = await isAdmin();
      if (!isAdminUser) {
        await _auth.signOut();
        throw Exception('Access denied. This account is not an admin.');
      }

      return credential;
    } catch (e) {
      if (kDebugMode) {
        print('Admin sign in error: $e');
      }
      rethrow;
    }
  }

  /// Sign out admin
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Admin sign out error: $e');
      }
      rethrow;
    }
  }

  /// Get current admin user
  User? get currentAdmin => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Check if admin is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Create admin user (for initial setup)
  /// Note: This should be called from a secure backend or manually
  Future<void> createAdminUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Create user in Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create admin document in Firestore
      await _firestore
          .collection(adminCollection)
          .doc(credential.user!.uid)
          .set({
            'email': email,
            'name': name,
            'isAdmin': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Set custom claim (requires backend/Cloud Functions)
      // For now, we'll rely on Firestore check
      if (kDebugMode) {
        print('Admin user created: ${credential.user!.uid}');
        print(
          'Note: Custom claims should be set via Cloud Functions for better security',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating admin user: $e');
      }
      rethrow;
    }
  }
}
