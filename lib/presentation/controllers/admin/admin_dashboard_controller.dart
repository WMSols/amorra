import 'package:get/get.dart';
import 'package:amorra/presentation/controllers/admin/admin_base_controller.dart';

/// Admin Dashboard Controller
/// Handles navigation state for admin dashboard
class AdminDashboardController extends AdminBaseController {
  // Navigation state
  final RxInt selectedIndex = 0.obs; // 0 = Users, 1 = Subscriptions

  /// Change selected tab
  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
