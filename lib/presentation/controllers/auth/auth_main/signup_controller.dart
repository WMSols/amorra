import 'package:amorra/core/config/routes.dart' as routes;
import 'package:amorra/core/utils/firebase_error_handler.dart';
import 'package:amorra/core/utils/validators.dart';
import 'package:amorra/data/repositories/auth_repository.dart';
import 'package:amorra/presentation/controllers/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Sign Up Controller
/// Handles sign up form logic and validation
class SignupController extends BaseController {
  // Repository - use Get.find to reuse existing instance
  AuthRepository get _authRepository => Get.find<AuthRepository>();

  // Form key - unique instance
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form controllers
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  final RxBool isPasswordVisible = false.obs;
  final RxBool isFormValid = false.obs;
  final RxBool isFromGoogle = false.obs;

  // Track if disposed
  bool _isDisposed = false;

  // Track if navigating
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    _isDisposed = false;
    _isNavigating = false;
    _setupValidation();
    _loadArguments();
  }

  /// Load route arguments
  void _loadArguments() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      // Pre-fill email from Google
      if (arguments['email'] != null) {
        emailController.text = arguments['email'].toString();
      }

      // Pre-fill name from Google
      if (arguments['displayName'] != null &&
          arguments['displayName'].toString().isNotEmpty) {
        fullnameController.text = arguments['displayName'].toString();
      }

      // Check if coming from Google sign-in
      if (arguments['fromGoogle'] != null) {
        isFromGoogle.value = arguments['fromGoogle'] as bool;
        if (kDebugMode) {
          print('📱 Signup from Google: ${isFromGoogle.value}');
        }
      }

      // Validate after loading arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && Get.isRegistered<SignupController>()) {
          try {
            validateForm();
          } catch (e) {
            if (kDebugMode && !_isDisposed) {
              debugPrint('Error validating form: $e');
            }
          }
        }
      });
    }
  }

  /// Setup form validation listeners
  void _setupValidation() {
    fullnameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  /// Validate entire form
  void validateForm() {
    if (_isDisposed) return;

    // Use Validators to check if fields are valid
    final fullnameValid =
        Validators.validateName(fullnameController.text.trim()) == null;
    final emailValid =
        Validators.validateEmail(emailController.text.trim()) == null;
    final passwordValid =
        Validators.validatePassword(passwordController.text) == null;

    isFormValid.value = fullnameValid && emailValid && passwordValid;
  }

  /// Private validate form
  void _validateForm() {
    if (_isDisposed) return;
    validateForm();
  }

  /// Validate fullname
  String? validateFullname(String? value) {
    return Validators.validateName(value);
  }

  /// Validate email
  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  /// Validate password
  String? validatePassword(String? value) {
    return Validators.validatePassword(value);
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    if (_isDisposed) return;
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Sign up user
  Future<void> signUp() async {
    if (_isDisposed || _isNavigating) return;

    if (!isFormValid.value) {
      showError(
        'Oops! Something\'s missing',
        subtitle: 'Please fill in all fields to create your account',
      );
      return;
    }

    try {
      setLoading(true);

      // Unfocus to dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      if (kDebugMode) {
        print('🚀 Starting signup - fromGoogle: ${isFromGoogle.value}');
      }

      // Create account (will automatically link Google if credential exists)
      await _authRepository.signUpWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: fullnameController.text.trim(),
      );

      if (_isDisposed || _isNavigating) return;

      showSuccess(
        'Account Created!',
        subtitle:
            'Your account has been created. Please verify your age to continue.',
      );

      _isNavigating = true;

      // Wait for UI to settle
      await Future.delayed(const Duration(milliseconds: 300));

      if (!_isDisposed) {
        // Navigate to age verification screen
        Get.offAllNamed(routes.AppRoutes.ageVerification);
      }
    } catch (e) {
      if (_isDisposed) return;
      final errorInfo = FirebaseErrorHandler.parseError(e);
      showError(errorInfo['title']!, subtitle: errorInfo['subtitle']!);
      _isNavigating = false;
    } finally {
      if (!_isDisposed) {
        setLoading(false);
      }
    }
  }

  /// Sign up with Google (direct Google signup without email/password)
  Future<void> signUpWithGoogle() async {
    if (_isDisposed || _isNavigating) return;

    try {
      setLoading(true);

      // Unfocus to dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      await _authRepository.signInWithGoogle();

      if (_isDisposed || _isNavigating) return;

      showSuccess(
        'Account Created!',
        subtitle:
            'Your account has been created with Google. Please verify your age to continue.',
      );

      _isNavigating = true;

      // Wait for UI to settle
      await Future.delayed(const Duration(milliseconds: 300));

      if (!_isDisposed) {
        // Navigate to age verification screen
        Get.offAllNamed(routes.AppRoutes.ageVerification);
      }
    } on SignupRequiredException catch (e) {
      if (_isDisposed) return;

      // This shouldn't happen on signup screen, but handle it
      setLoading(false);
      _isNavigating = false;

      showInfo(
        'Complete Your Profile',
        subtitle: 'Please fill in your details to complete signup.',
      );

      // Pre-fill the form
      if (e.email.isNotEmpty) {
        emailController.text = e.email;
      }
      if (e.displayName != null && e.displayName!.isNotEmpty) {
        fullnameController.text = e.displayName!;
      }
      isFromGoogle.value = true;
      validateForm();
    } catch (e) {
      if (_isDisposed) return;
      final errorInfo = FirebaseErrorHandler.parseError(e);
      showError(errorInfo['title']!, subtitle: errorInfo['subtitle']!);
      _isNavigating = false;
    } finally {
      if (!_isDisposed) {
        setLoading(false);
      }
    }
  }

  /// Sign up / sign in with Apple
  Future<void> signUpWithApple() async {
    if (_isDisposed || _isNavigating) return;

    try {
      setLoading(true);

      // Unfocus to dismiss keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      await _authRepository.signInWithApple();

      if (_isDisposed || _isNavigating) return;

      showSuccess(
        'Account Ready!',
        subtitle:
            'You\'re signed in with Apple. Please verify your age to continue.',
      );

      _isNavigating = true;
      await Future.delayed(const Duration(milliseconds: 300));

      if (!_isDisposed) {
        Get.offAllNamed(routes.AppRoutes.ageVerification);
      }
    } catch (e) {
      if (_isDisposed) return;
      final errorInfo = FirebaseErrorHandler.parseError(e);
      showError(errorInfo['title']!, subtitle: errorInfo['subtitle']!);
      _isNavigating = false;
    } finally {
      if (!_isDisposed) {
        setLoading(false);
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    fullnameController.removeListener(_validateForm);
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
