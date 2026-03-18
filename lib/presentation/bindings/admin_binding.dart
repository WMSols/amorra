import 'package:get/get.dart';
import 'package:amorra/presentation/controllers/admin/admin_auth_controller.dart';
import 'package:amorra/presentation/controllers/admin/admin_user_controller.dart';
import 'package:amorra/presentation/controllers/admin/admin_subscription_controller.dart';
import 'package:amorra/presentation/controllers/admin/admin_dashboard_controller.dart';

/// Admin Binding
/// Initializes admin controllers
class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminAuthController(), fenix: true);
    Get.lazyPut(() => AdminDashboardController(), fenix: true);
    Get.lazyPut(() => AdminUserController(), fenix: true);
    Get.lazyPut(() => AdminSubscriptionController(), fenix: true);
  }
}
