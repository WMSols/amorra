import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amorra/core/constants/app_constants.dart';
import 'package:amorra/data/models/user_model.dart';
import 'package:amorra/data/models/subscription_model.dart';
import 'package:flutter/foundation.dart';

/// Admin Service
/// Handles admin operations for User and Subscription management
/// Directly interacts with Firestore
class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER MANAGEMENT ====================

  /// Get users stream with optional filters
  /// Returns real-time stream of users
  Stream<List<UserModel>> getUsersStream({
    bool? isBlocked,
    String? subscriptionStatus,
    bool? isOnboardingCompleted,
    bool? isAgeVerified,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) {
    try {
      Query query = _firestore.collection(AppConstants.collectionUsers);

      // Apply filters
      if (isBlocked != null) {
        query = query.where('isBlocked', isEqualTo: isBlocked);
      }
      if (subscriptionStatus != null) {
        query = query.where(
          'subscriptionStatus',
          isEqualTo: subscriptionStatus,
        );
      }
      if (isOnboardingCompleted != null) {
        query = query.where(
          'isOnboardingCompleted',
          isEqualTo: isOnboardingCompleted,
        );
      }
      if (isAgeVerified != null) {
        query = query.where('isAgeVerified', isEqualTo: isAgeVerified);
      }
      if (createdAfter != null) {
        query = query.where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(createdAfter),
        );
      }
      if (createdBefore != null) {
        query = query.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(createdBefore),
        );
      }

      // Order by creation date (newest first)
      query = query.orderBy('createdAt', descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data() as Map<String, dynamic>;
            return UserModel.fromJson({'id': doc.id, ...data});
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing user document ${doc.id}: $e');
            }
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting users stream: $e');
      }
      rethrow;
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() ?? {};
      return UserModel.fromJson({'id': doc.id, ...data});
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user by ID: $e');
      }
      rethrow;
    }
  }

  /// Search users by name or email
  Future<List<UserModel>> searchUsers(String searchQuery) async {
    try {
      final query = searchQuery.toLowerCase().trim();
      if (query.isEmpty) {
        return [];
      }

      // Firestore doesn't support full-text search, so we'll search by name prefix
      // For production, consider using Algolia or similar for better search
      final snapshot = await _firestore
          .collection(AppConstants.collectionUsers)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(50)
          .get();

      // Also search by email if query contains @
      List<UserModel> results = [];
      if (query.contains('@')) {
        final emailSnapshot = await _firestore
            .collection(AppConstants.collectionUsers)
            .where('email', isEqualTo: query)
            .limit(10)
            .get();

        results.addAll(
          emailSnapshot.docs.map((doc) {
            final data = doc.data();
            return UserModel.fromJson({'id': doc.id, ...data});
          }),
        );
      }

      // Add name search results
      results.addAll(
        snapshot.docs.map((doc) {
          final data = doc.data();
          return UserModel.fromJson({'id': doc.id, ...data});
        }),
      );

      // Remove duplicates
      final uniqueResults = <String, UserModel>{};
      for (var user in results) {
        uniqueResults[user.id] = user;
      }

      return uniqueResults.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching users: $e');
      }
      rethrow;
    }
  }

  /// Update user
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow;
    }
  }

  /// Block user
  Future<void> blockUser(String userId, {String? reason}) async {
    try {
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({
            'isBlocked': true,
            'blockedAt': FieldValue.serverTimestamp(),
            'blockReason': reason,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error blocking user: $e');
      }
      rethrow;
    }
  }

  /// Unblock user
  Future<void> unblockUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({
            'isBlocked': false,
            'blockedAt': FieldValue.delete(),
            'blockReason': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error unblocking user: $e');
      }
      rethrow;
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user document
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .delete();

      // Note: In production, you might want to also:
      // - Delete user's messages
      // - Delete user's subscriptions
      // - Delete user's preferences
      // - Delete from Firebase Auth
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
      rethrow;
    }
  }

  /// Grant or extend free trial
  Future<void> grantFreeTrial(String userId, {int days = 7}) async {
    try {
      final user = await getUserById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final now = DateTime.now();
      final trialEndDate = now.add(Duration(days: days));

      // Update user with trial end date
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .update({
            'freeTrialEndDate': Timestamp.fromDate(trialEndDate),
            'freeTrialGrantedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error granting free trial: $e');
      }
      rethrow;
    }
  }

  // ==================== SUBSCRIPTION MANAGEMENT ====================

  /// Get subscriptions stream with optional filters
  Stream<List<SubscriptionModel>> getSubscriptionsStream({
    String? status,
    String? planName,
    DateTime? startDateAfter,
    DateTime? startDateBefore,
  }) {
    try {
      Query query = _firestore.collection(AppConstants.collectionSubscriptions);

      // Apply filters
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }
      if (planName != null) {
        query = query.where('planName', isEqualTo: planName);
      }
      if (startDateAfter != null) {
        query = query.where(
          'startDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDateAfter),
        );
      }
      if (startDateBefore != null) {
        query = query.where(
          'startDate',
          isLessThanOrEqualTo: Timestamp.fromDate(startDateBefore),
        );
      }

      // Order by creation date (newest first)
      query = query.orderBy('createdAt', descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data() as Map<String, dynamic>;
            return SubscriptionModel.fromJson({'id': doc.id, ...data});
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing subscription document ${doc.id}: $e');
            }
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting subscriptions stream: $e');
      }
      rethrow;
    }
  }

  /// Get subscription by ID
  Future<SubscriptionModel?> getSubscriptionById(String subscriptionId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .doc(subscriptionId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() ?? {};
      return SubscriptionModel.fromJson({'id': doc.id, ...data});
    } catch (e) {
      if (kDebugMode) {
        print('Error getting subscription by ID: $e');
      }
      rethrow;
    }
  }

  /// Get subscriptions by user ID
  Future<List<SubscriptionModel>> getSubscriptionsByUserId(
    String userId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SubscriptionModel.fromJson({'id': doc.id, ...data});
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting subscriptions by user ID: $e');
      }
      rethrow;
    }
  }

  /// Update subscription
  Future<void> updateSubscription(
    String subscriptionId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .doc(subscriptionId)
          .update(updates);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating subscription: $e');
      }
      rethrow;
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription(
    String subscriptionId, {
    String? reason,
  }) async {
    try {
      final subscription = await getSubscriptionById(subscriptionId);
      if (subscription == null) {
        throw Exception('Subscription not found');
      }

      // Update subscription
      await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .doc(subscriptionId)
          .update({
            'status': AppConstants.subscriptionStatusCancelled,
            'cancelledAt': FieldValue.serverTimestamp(),
            'cancelReason': reason,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update user's subscription status
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(subscription.userId)
          .update({
            'isSubscribed': false,
            'subscriptionStatus': AppConstants.subscriptionStatusCancelled,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error cancelling subscription: $e');
      }
      rethrow;
    }
  }

  /// Reactivate cancelled subscription
  Future<void> reactivateSubscription(String subscriptionId) async {
    try {
      final subscription = await getSubscriptionById(subscriptionId);
      if (subscription == null) {
        throw Exception('Subscription not found');
      }

      final now = DateTime.now();
      final endDate = subscription.endDate ?? now.add(const Duration(days: 30));

      // Update subscription
      await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .doc(subscriptionId)
          .update({
            'status': AppConstants.subscriptionStatusActive,
            'startDate': Timestamp.fromDate(now),
            'endDate': Timestamp.fromDate(endDate),
            'cancelledAt': FieldValue.delete(),
            'cancelReason': FieldValue.delete(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update user's subscription status
      await _firestore
          .collection(AppConstants.collectionUsers)
          .doc(subscription.userId)
          .update({
            'isSubscribed': true,
            'subscriptionStatus': AppConstants.subscriptionStatusActive,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error reactivating subscription: $e');
      }
      rethrow;
    }
  }

  /// Get subscription analytics
  Future<Map<String, dynamic>> getSubscriptionAnalytics() async {
    try {
      final subscriptionsSnapshot = await _firestore
          .collection(AppConstants.collectionSubscriptions)
          .get();

      final subscriptions = subscriptionsSnapshot.docs.map((doc) {
        final data = doc.data();
        return SubscriptionModel.fromJson({'id': doc.id, ...data});
      }).toList();

      final active = subscriptions
          .where((s) => s.status == AppConstants.subscriptionStatusActive)
          .length;
      final cancelled = subscriptions
          .where((s) => s.status == AppConstants.subscriptionStatusCancelled)
          .length;
      final expired = subscriptions
          .where((s) => s.status == AppConstants.subscriptionStatusExpired)
          .length;

      final totalRevenue = subscriptions
          .where(
            (s) =>
                s.price != null &&
                s.status == AppConstants.subscriptionStatusActive,
          )
          .fold<double>(0.0, (sum, s) => sum + (s.price ?? 0.0));

      final monthlyRevenue = subscriptions
          .where((s) {
            if (s.price == null ||
                s.status != AppConstants.subscriptionStatusActive) {
              return false;
            }
            if (s.startDate == null) return false;
            final now = DateTime.now();
            final startOfMonth = DateTime(now.year, now.month, 1);
            return s.startDate!.isAfter(startOfMonth) ||
                s.startDate!.isAtSameMomentAs(startOfMonth);
          })
          .fold<double>(0.0, (sum, s) => sum + (s.price ?? 0.0));

      return {
        'totalSubscriptions': subscriptions.length,
        'activeSubscriptions': active,
        'cancelledSubscriptions': cancelled,
        'expiredSubscriptions': expired,
        'totalRevenue': totalRevenue,
        'monthlyRevenue': monthlyRevenue,
        'averageRevenuePerUser': active > 0 ? totalRevenue / active : 0.0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting subscription analytics: $e');
      }
      rethrow;
    }
  }

  /// Get user analytics
  Future<Map<String, dynamic>> getUserAnalytics() async {
    try {
      final usersSnapshot = await _firestore
          .collection(AppConstants.collectionUsers)
          .get();

      final users = usersSnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromJson({'id': doc.id, ...data});
      }).toList();

      final total = users.length;
      final subscribed = users.where((u) => u.isSubscribed).length;
      final blocked = users.where((u) => u.isBlocked).length;
      final onboardingCompleted = users
          .where((u) => u.isOnboardingCompleted)
          .length;
      final ageVerified = users.where((u) => u.isAgeVerified).length;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final thisWeek = today.subtract(const Duration(days: 7));
      final thisMonth = DateTime(now.year, now.month, 1);

      final newToday = users.where((u) => u.createdAt.isAfter(today)).length;
      final newThisWeek = users
          .where((u) => u.createdAt.isAfter(thisWeek))
          .length;
      final newThisMonth = users
          .where((u) => u.createdAt.isAfter(thisMonth))
          .length;

      return {
        'totalUsers': total,
        'subscribedUsers': subscribed,
        'blockedUsers': blocked,
        'onboardingCompleted': onboardingCompleted,
        'ageVerified': ageVerified,
        'newUsersToday': newToday,
        'newUsersThisWeek': newThisWeek,
        'newUsersThisMonth': newThisMonth,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user analytics: $e');
      }
      rethrow;
    }
  }
}
