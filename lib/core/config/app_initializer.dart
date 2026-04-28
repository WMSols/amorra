import 'package:amorra/core/utils/app_colors/app_colors.dart';
import 'package:amorra/presentation/controllers/theme/theme_controller.dart';
import 'package:amorra/data/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'firebase_config.dart';

/// App Initializer
/// Handles all app initialization logic
class AppInitializer {
  /// Initialize all required services and dependencies
  static Future<void> initialize() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set status bar color globally
    _setStatusBarStyle();

    // Initialize environment variables
    await _initializeEnvironment();

    // Initialize GetStorage
    await _initializeStorage();

    // Initialize Firebase
    await _initializeFirebase();

    // Initialize Stripe (optional - can also be initialized on-demand)
    await _initializeStripe();

    // Initialize Meta/Facebook App Events (optional)
    await _initializeFacebookAppEvents();

    // Initialize GetX controllers
    _initializeControllers();
  }

  /// Initialize environment variables from .env file
  static Future<void> _initializeEnvironment() async {
    try {
      await dotenv.load(fileName: '.env');
      if (kDebugMode) {
        debugPrint('Environment variables loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Environment variables initialization error: $e');
        debugPrint('Continuing without .env file (using defaults)');
      }
      // Continue app initialization even if .env fails (for development)
    }
  }

  /// Set status bar style for the whole app
  static void _setStatusBarStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness:
            Brightness.dark, // Dark icons for white background
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  /// Initialize local storage
  static Future<void> _initializeStorage() async {
    try {
      await GetStorage.init();
      if (kDebugMode) {
        debugPrint('GetStorage initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GetStorage initialization error: $e');
      }
    }
  }

  /// Initialize Firebase services
  static Future<void> _initializeFirebase() async {
    try {
      await FirebaseConfig.initialize();
      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firebase initialization error: $e');
        // Continue app initialization even if Firebase fails (for development)
      }
    }
  }

  /// Initialize Stripe payment service (TEST MODE ONLY)
  ///
  /// IMPORTANT: This app is configured for TEST MODE only.
  /// Use Stripe TEST publishable keys (starting with 'pk_test_')
  /// from Stripe Dashboard > Developers > API keys > Test mode
  ///
  /// iOS Configuration:
  /// - URL scheme configured in Info.plist: com.example.amorra
  /// - Camera permission for card scanning: NSCameraUsageDescription
  /// - Apple Pay merchant identifier (optional): Set STRIPE_MERCHANT_IDENTIFIER in .env
  ///
  /// This is optional - Stripe can also be initialized on-demand when needed
  static Future<void> _initializeStripe() async {
    try {
      // Get Stripe publishable key from environment
      final publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];

      if (publishableKey != null && publishableKey.isNotEmpty) {
        // Validate test mode key
        if (!publishableKey.startsWith('pk_test_')) {
          if (kDebugMode) {
            debugPrint('⚠️ WARNING: Stripe key does not start with "pk_test_"');
            debugPrint('  This app is configured for TEST MODE only.');
            debugPrint('  Please use a Stripe TEST publishable key.');
          }
        }

        // Get merchant identifier for iOS Apple Pay (optional)
        final merchantIdentifier = dotenv.env['STRIPE_MERCHANT_IDENTIFIER'];

        final stripeService = StripeService();
        await stripeService.initialize(
          publishableKey,
          merchantIdentifier: merchantIdentifier,
        );
        if (kDebugMode) {
          debugPrint('✅ Stripe initialized successfully (TEST MODE)');
          if (merchantIdentifier != null) {
            debugPrint(
              '  - Apple Pay: Enabled (Merchant ID: $merchantIdentifier)',
            );
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint(
            'ℹ️ Stripe publishable key not found - will initialize on-demand',
          );
          debugPrint(
            '  Stripe will be initialized when user attempts to purchase',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Stripe initialization error: $e');
        debugPrint('  Stripe will be initialized on-demand when needed');
      }
      // Continue app initialization - Stripe can be initialized later
    }
  }

  /// Initialize Meta/Facebook App Events.
  ///
  /// This is optional and safe to skip if Meta SDK values are not configured.
  static Future<void> _initializeFacebookAppEvents() async {
    try {
      final appId = dotenv.env['FACEBOOK_APP_ID'];
      final clientToken = dotenv.env['FACEBOOK_CLIENT_TOKEN'];
      if (appId == null ||
          appId.isEmpty ||
          clientToken == null ||
          clientToken.isEmpty) {
        if (kDebugMode) {
          debugPrint(
            'ℹ️ Facebook App Events not configured (FACEBOOK_APP_ID / FACEBOOK_CLIENT_TOKEN missing)',
          );
        }
        return;
      }

      final facebookAppEvents = FacebookAppEvents();
      await facebookAppEvents.setAutoLogAppEventsEnabled(true);

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final trackingStatus =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (trackingStatus == TrackingStatus.notDetermined) {
          await AppTrackingTransparency.requestTrackingAuthorization();
        }
      }

      if (kDebugMode) {
        debugPrint('✅ Facebook App Events initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Facebook App Events initialization error: $e');
      }
      // Do not block app launch if Meta SDK init fails.
    }
  }

  /// Initialize GetX controllers
  static void _initializeControllers() {
    // Initialize theme controller
    Get.put(ThemeController(), permanent: true);

    if (kDebugMode) {
      debugPrint('GetX controllers initialized');
    }
  }
}
