import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:amorra/data/services/admin_auth_service.dart';
import 'package:amorra/presentation/controllers/admin/admin_base_controller.dart';
import 'package:amorra/core/config/routes.dart';

/// Admin Auth Controller
/// Handles admin authentication state and operations
class AdminAuthController extends AdminBaseController {
  final AdminAuthService _adminAuthService = AdminAuthService();

  // State
  final RxBool isAuthenticated = false.obs;
  final RxBool isAdmin = false.obs;

  // Stream subscription for auth state changes
  StreamSubscription? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
    _setupAuthListener();
  }

  @override
  void onClose() {
    // Cancel auth state listener subscription
    _authStateSubscription?.cancel();
    _authStateSubscription = null;
    super.onClose();
  }

  /// Setup auth state listener
  void _setupAuthListener() {
    // Cancel existing subscription if any
    _authStateSubscription?.cancel();

    _authStateSubscription = _adminAuthService.authStateChanges.listen(
      (user) async {
        isAuthenticated.value = user != null;
        if (user != null) {
          try {
            // Check if user is admin
            final adminStatus = await _adminAuthService.isAdmin();
            isAdmin.value = adminStatus;

            if (!adminStatus) {
              // User is not admin, sign them out
              await signOut();
              showError(
                'Access Denied',
                subtitle: 'This account is not authorized as admin.',
              );
            } else {
              // User is admin, navigate to dashboard if not already there
              if (Get.currentRoute != AppRoutes.adminDashboard) {
                Get.offAllNamed(AppRoutes.adminDashboard);
              }
            }
          } catch (e) {
            // If checking admin status fails, treat as not admin
            if (kDebugMode) {
              print('Error checking admin status in listener: $e');
            }
            isAdmin.value = false;
            // Don't sign out here to avoid loops, let the auth state handle it
          }
        } else {
          isAdmin.value = false;
          // User signed out, navigate to login if not already there
          // Only navigate if controller is still active
          if (!isClosed && Get.currentRoute != AppRoutes.adminLogin) {
            Get.offAllNamed(AppRoutes.adminLogin);
          }
        }
      },
      onError: (error) {
        // Silently handle errors after sign out (permission errors are expected)
        if (kDebugMode) {
          print(
            'Auth state listener error (may be expected after sign out): $error',
          );
        }
        // Don't call setError here to avoid logging expected permission errors
      },
    );
  }

  /// Check current auth state
  Future<void> _checkAuthState() async {
    // Don't check if controller is closed
    if (isClosed) return;

    try {
      final user = _adminAuthService.currentAdmin;
      isAuthenticated.value = user != null;
      isAdmin.value = false; // Reset admin status

      if (user != null && !isClosed) {
        try {
          final adminStatus = await _adminAuthService.isAdmin();
          if (!isClosed) {
            isAdmin.value = adminStatus;

            if (!adminStatus) {
              await signOut();
            }
          }
        } catch (e) {
          // If checking admin status fails (e.g., permission denied),
          // user is likely not authenticated or not admin
          // Only log if it's not a permission error (expected after sign out)
          final errorString = e.toString();
          if (!errorString.contains('permission-denied') && kDebugMode) {
            print('Error checking admin status: $e');
          }
          if (!isClosed) {
            isAdmin.value = false;
          }
          // Don't sign out here as it might cause infinite loops
        }
      }
    } catch (e) {
      // Only log non-permission errors
      final errorString = e.toString();
      if (!errorString.contains('permission-denied') && kDebugMode) {
        print('Error checking auth state: $e');
      }
      // Ensure state is reset on error
      if (!isClosed) {
        isAuthenticated.value = false;
        isAdmin.value = false;
      }
    }
  }

  /// Sign in admin
  Future<bool> signIn(String email, String password) async {
    try {
      setLoading(true);
      await _adminAuthService.signInAdmin(email, password);

      // Verify admin status
      final adminStatus = await _adminAuthService.isAdmin();
      if (!adminStatus) {
        await signOut();
        showError(
          'Access Denied',
          subtitle: 'This account is not authorized as admin.',
        );
        setLoading(false);
        return false;
      }

      isAuthenticated.value = true;
      isAdmin.value = true;
      setLoading(false);
      showSuccess('Signed in successfully');

      // Navigate to dashboard
      Get.offAllNamed(AppRoutes.adminDashboard);
      return true;
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      showError('Sign in failed', subtitle: errorMessage);
      return false;
    }
  }

  /// Sign out admin
  Future<void> signOut() async {
    try {
      setLoading(true);
      await _adminAuthService.signOut();
      isAuthenticated.value = false;
      isAdmin.value = false;
      setLoading(false);
    } catch (e) {
      setError(e.toString());
      setLoading(false);
      showError('Sign out failed', subtitle: e.toString());
    }
  }

  /// Get current admin email
  String? get currentAdminEmail => _adminAuthService.currentAdmin?.email;
}
