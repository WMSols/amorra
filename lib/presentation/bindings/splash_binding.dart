import 'package:get/get.dart';
import 'package:amorra/presentation/controllers/splash/splash_controller.dart';
import 'package:amorra/data/repositories/auth_repository.dart';

/// Splash Binding
/// Dependency injection for splash screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthRepository is available
    if (!Get.isRegistered<AuthRepository>()) {
      Get.put(AuthRepository(), permanent: true);
    }

    Get.lazyPut(() => SplashController());
  }
}
