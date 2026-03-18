import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API Constants
/// Contains API endpoints and configuration
class ApiConstants {
  // Base URLs - Load from environment variables (no hardcoded URL fallback).
  static String get baseUrl => (dotenv.env['API_BASE_URL'] ?? '').trim();
  static String get aiApiBaseUrl =>
      dotenv.env['AI_API_BASE_URL'] ?? 'https://api.openai.com/v1';

  // API Endpoints
  static const String endpointChat = '/api/chat';
  static const String endpointChatCompletions = '/chat/completions';
  static const String endpointModeration = '/moderations';
  // Payment Intent Endpoint: /api/create-payment-intent
  static const String endpointCreatePaymentIntent =
      '/api/create-payment-intent';
  // Update Context Endpoint: /api/update-context
  static const String endpointUpdateContext = '/api/update-context';

  // Headers
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerBearer = 'Bearer';
  static const String headerApiKey = 'X-API-Key';
  static const String contentTypeJson = 'application/json';

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Chat API Timeout - AI responses can take longer, so we use a longer timeout
  static const Duration chatApiTimeout = Duration(
    seconds: 600,
  ); // 10 minutes for AI responses

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
